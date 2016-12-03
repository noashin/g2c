import json
import requests


class AllenImageSyncroSDK(object):
    def __init__(self,base_url ='http://api.brain-map.org/api/v2/'):
        self.base_url = base_url
    def image_to_atlas(self,SectionImageId,x,y,atlas_id,session=requests.session()):
        url = self.base_url + 'image_to_atlas/%d.json?x=%f&y=%f&atlas_id=%d'%(SectionImageId,x,y,atlas_id)
        return self.process_simple_url_request(url,session)
        
    def reference_to_image(self,ReferenceSpaceId,x,y,z,section_data_set_ids=[],session=requests.session()):
        data_set_string=','.join([str(id) for id in section_data_set_ids])
        url = self.base_url + 'reference_to_image/%d.json?x=%f&y=%f&z=%f&&section_data_set_ids=%s'%(ReferenceSpaceId,x,y,z,data_set_string)
        json= self.process_simple_url_request(url,session)
        return json
        #returns section_image_id,section_number,x,y
    def image_to_reference(self,SectionImageId,x,y,session=requests.session()):
        #http://api.brain-map.org/api/v2/image_to_reference/[SectionImage.id].[xml|json]?x=[#]&y=[#]
        url = self.base_url + 'image_to_reference/%d.json&x=%f,y=%f'%(SectionImageId,x,y)
        return self.process_simple_url_request(url,session)    
        #return x,y,z
  
    def process_simple_url_request(self,request_url,session):
        r = session.get(request_url)
        try:
            #print(r.json())
            return r.json()
        except:
            #print e
            print(r.text)
            return None