import api_geographic_data_importer as agdi
import sys

def main() -> int:
    geo_data = agdi.api_geographic_data_importer()
    geo_data.connexion()
    geo_data.load_geo_department_data()
    geo_data.save_geo_depart()
    geo_data.load_geo_communes()
    return 0

if __name__== "__main__":
    sys.exit(main())
