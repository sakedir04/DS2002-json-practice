import json


with open('../data/schacon.repos.json', 'r') as file:
    data = json.load(file)


with open('chacon.csv', 'w') as out_file:
    for repo in data[:5]:  
        name = repo.get("name")
        html_url = repo.get("html_url")
        updated_at = repo.get("updated_at")
        visibility = repo.get("visibility", "public")
        out_file.write(f"{name},{html_url},{updated_at},{visibility}\n")

