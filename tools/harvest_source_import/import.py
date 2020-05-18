'''
Harvest source import
'''

import argparse
from remote_ckan.lib import RemoteCKAN

parser = argparse.ArgumentParser()
parser.add_argument("--origin_url", type=str, default='https://catalog.data.gov', help="CKAN instance URL")
parser.add_argument("--source_type", type=str, default='ALL', help="Tipe of harvest source: ALL|datajson|csw|waf etc")
parser.add_argument("--user_agent", type=str, default='CKAN-harvest-source-importer 1.0', help="User agent")
parser.add_argument("--destination_url", type=str, default='http://ckan:5000', help="CKAN destination instance URL")
parser.add_argument("--destination_api_key", type=str, help="CKAN destination instance API KEY")
parser.add_argument("--destination_owner_org", type=str, help="CKAN destination Organization for all Harvest sources")

args = parser.parse_args()

ckan = RemoteCKAN(url=args.origin_url, user_agent=args.user_agent)
ckan.set_destination(ckan_url=args.destination_url, ckan_api_key=args.destination_api_key)

harvest_sources = []
for hs in ckan.list_harvest_sources(source_type=args.source_type):
    harvest_sources.append(hs)

ok = 0
failed = 0
already_exists = 0
for hs in harvest_sources:
    # save to destination CKAN
    
    created, status_code, error = ckan.create_harvest_source(data=hs, owner_org_id=args.destination_owner_org)
    if created: 
        ok += 1
    elif status_code == 409:
        already_exists += 1
    else:
        failed += 1

print('Finished: {} harvest sources. {} Added, {} already exists, {} failed'.format(len(harvest_sources), ok, already_exists, failed))
