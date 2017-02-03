import pandas as pd
import urllib
import xml.etree.ElementTree as ET
import glob
import subprocess
import os


# ### Get section name acronyms from connectivity matrix
section_names = pd.read_csv('./nature13186-s2.csv')
all_gene_acronyms = list(section_names['Acronym'])

genes_csv = pd.read_csv('../../all_developing_mouse_brain_genes.csv')
gene_ids = genes_csv['id']
gene_acronyms = genes_csv['gene_symbol']

# ### Use allan brain atlas "API" to query all relevant gene expression experiments and extract their corresponding SectionDataSet IDs
exp_ids = []
for i, acr in enumerate(gene_acronyms):
    # query all experiments related to one gene
    query = "http://api.brain-map.org/api/v2/data/query.xml?criteria=model::SectionDataSet,genes[acronym$eq'" + acr +"']"
    f = urllib.urlopen(query)
    xml_data = f.read()
    f.close()
    
    # scrape the returned xml file for section data ids of all experiments
    root = ET.fromstring(xml_data)
    for section_data_set in root.findall('.//section-data-set'):
        IDs = section_data_set.findall('id')
        assert len(IDs) <= 1
        exp_ids.append(IDs[0].text)
    print('Done with extracting SectionDataSet id for gene expression data of {} ({}/{})'.format(acr, i+1, len(gene_acronyms)))
print("len(exp_ids) = {}, len(set(exp_ids)) = {}".format(len(exp_ids), len(set(exp_ids))))
print('Set of experiment IDs ({}):\n'.format(len(set(exp_ids))), set(exp_ids))

# ### Download data sets for each SectionDataSet ID
data_dir = './gene_expression_data/'
return_codes = []
stderrs = []
ids_per_proc = []
procs_ids = []
for i, exp_id in enumerate(exp_ids):
    url = 'http://api.brain-map.org/grid_data/download/' + exp_id
    proc = subprocess.Popen(['wget', 
                             '-P',
                             data_dir, 
                             '--content-disposition', 
                             url],
                            stderr=subprocess.PIPE)
    procs_ids.append((proc, exp_id))
    if (i+1) % 100 == 0:
        # wait for all processes to finish
        print('Waiting for files {} - {} to download...'.format(i+1-100, i+1))
        for p, exp_id in procs_ids:
            return_codes.append(p.wait())
            stderrs.append(p.communicate())
            ids_per_proc.append(exp_id)
        procs_ids = []
        print('Done with downloading {}/{} files.'.format(i+1, len(exp_ids)))
        
# wait for the last processes to finish
for p, exp_id in procs_ids:
    return_codes.append(p.wait())
    stderrs.append(p.communicate())
    ids_per_proc.append(exp_id)
                            
num_failed = 0
for i in range(len(exp_ids)):
    if return_codes[i] != 0:
        print("\nID {} couldn't be downloaded, rc = {}:".format(ids_per_proc[i], return_codes[i]))
        print(str(stderrs[i][1]))
        num_failed += 1
        
print('\n{} / {} downloads failed.'.format(num_failed, len(exp_ids)))


# ## Sort downloaded files into coronal and sagittal
coronal_dir = 'coronal_data'
sagittal_dir = 'sagittal_data'
if not os.path.exists(data_dir + coronal_dir):
    os.makedirs(data_dir + coronal_dir)
if not os.path.exists(data_dir + sagittal_dir):
    os.makedirs(data_dir + sagittal_dir)
    
for zipfile in glob.glob(data_dir + '/*'):
    abspath = os.path.abspath(zipfile)
    dirname, basename = os.path.split(abspath)
    if 'coronal' in basename and coronal_dir not in basename:
        new_dir = dirname + '/' + coronal_dir + '/' + basename
        os.rename(abspath, new_dir)
    elif 'sagittal' in basename and sagittal_dir not in basename:
        new_dir = dirname + '/' + sagittal_dir + '/' + basename
        os.rename(abspath, new_dir)

# ## Sort downloaded files into developmental stages
dev_dirs = ['E11.5', 'E13.5', 'E15.5', 'E18.5', 'P4', 'P56', 'P14', 'P28', 'P56']
