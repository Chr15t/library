import pandas as pd


df = pd.read_csv("french_library_data_link_download.csv")



formatted_text = ""
output_file = "fr_links.txt"

with open(output_file, 'w') as f:
  for index, row in df.iterrows():
      # formatted_text += f"Link: {row['links']}\n"
      f.write(f"{row['links']}\n")

# print(formatted_text)