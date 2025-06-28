import pandas as pd

df_comuni = pd.read_csv("original (csv file)/cities.csv", sep=";")

print(df_comuni.columns)

#Remove white space in front of the column names
df_comuni.columns = df_comuni.columns.str.strip()

#Drop unnecessary columns from the DataFrame
df_comuni = df_comuni.drop(columns=["codice_istat", 
                                    "denominazione_ita_altra", 
                                    "denominazione_altra", 
                                    "tipologia_provincia", 
                                    "codice_regione", 
                                    "tipologia_regione",
                                    "ripartizione_geografica",
                                    "flag_capoluogo", 
                                    "codice_belfiore", 
                                    "superficie_kmq"])

# Convert longitude and latitue , to .
df_comuni["lat"] = df_comuni["lat"].str.replace(",", ".").astype(float)
df_comuni["lon"] = df_comuni["lon"].str.replace(",", ".").astype(float)

#Save the cleaned DataFrame to a new CSV file
df_comuni.to_csv("authentication-service/src/main/resources/cities_cleaned.csv", index=False)