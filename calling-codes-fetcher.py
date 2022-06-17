import pycountry
import phonenumbers
from collections import OrderedDict

dictio = {}

countries = pycountry.countries

for country in countries:
    temp = {}
    
    dial = phonenumbers.country_code_for_region(country.alpha_2)
    
    temp["country_code"] = country.alpha_2
    temp["dial_code"] = dial
    
    dictio[country.name] = temp
    
print({key: value for key, value in sorted(dictio.items())})