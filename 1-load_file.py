'''
*********************************************************************************************
Libraries
*********************************************************************************************
'''
import json
import pandas as pd
from pathlib import Path

'''
*********************************************************************************************
Variables
*********************************************************************************************
'''
input_file_path = r"prueba_dataknow\Datos3"
input_file_name = "OFEI1204.txt"
output_path = r"prueba_dataknow"
output_json_name = "OFEI1204.json"
output_csv_name = "primer_ejercicio.csv"

file_dict = {"agents": {}}
agent = None

'''
*********************************************************************************************
Functions
*********************************************************************************************
'''   
def isAnEmptyLine(line)->bool:
    """
    Check if a line is empty.

    Args:
        line (str): The line to check.

    Returns:
        bool: True if the line is empty, False otherwise.
    """
    return len(line.strip()) == 0

def parse_file_to_dict(input_file_path):  
    """
    Parses a file and returns a dictionary containing the extracted data.
    Args:
        input_file_path (str): The path to the input file.
    Returns:
        dict: A dictionary containing the extracted data from the file.
    Raises:
        FileNotFoundError: If the input file is not found.
    """
    try:
        with open(input_file_path, "r", encoding="utf8") as file:
            for i, line in enumerate(file):
                if isAnEmptyLine(line):
                    continue
                
                if line.startswith("Oferta"):
                    file_date = line.split()[-1]
                    file_dict["date"] = file_date
                    
                elif line.startswith("AGENTE"):
                    agent = line.split(": ")[-1].strip("\n")
                    file_dict["agents"][agent] = {}
                
                elif agent is not None:
                    lineArray = line.strip("\n").split(" , ")
                    file_dict["agents"][agent][i] = {
                        "station": lineArray[0],
                        "type": lineArray[1].split(", ")[0]
                    }
                    
                    details = lineArray[1].split(", ")[1:]
                    if file_dict["agents"][agent][i]["type"] == "D":
                        file_dict["agents"][agent][i]["hours"] = details
                    else:
                        file_dict["agents"][agent][i]["other"] = details
    
    except FileNotFoundError:
        print(f"File not found: {input_file_path}")
        return None

    return file_dict

def write_json(file_dict, output_path)->None:
    """
    Write a dictionary to a JSON file.

    Parameters:
    - file_dict (dict): The dictionary to be written to the JSON file.
    - output_path (str): The path of the output JSON file.

    Raises:
    - IOError: If there is an error while writing the JSON file.

    """
    try:
        with open(output_path, 'w', encoding='utf8') as json_file:
            json.dump(file_dict, json_file, ensure_ascii=False, indent=4)
    except IOError as e:
        print(f"Failed to write JSON file: {e}")

def parse_dict_to_df(file_dict:dict)->pd.DataFrame:
    """
    Parses a dictionary into a pandas DataFrame.
    Args:
        file_dict (dict): The dictionary containing the data to be parsed.
    Returns:
        pd.DataFrame: The parsed data as a pandas DataFrame.
    Raises:
        None
    """
    try:        
        new_rows = []

        for agent, records in file_dict["agents"].items():
            for register in records.values():
                if register["type"] == "D":
                    new_row = {
                        "Agente": agent,
                        "Planta": register["station"],
                        **{f"Hora_{i+1}": float(hour) for i, hour in enumerate(register["hours"])}
                    }
                    new_rows.append(new_row)

        return pd.DataFrame(new_rows)
    
    except:
        return pd.DataFrame()

def save_dataframe_to_csv(df, output_csv_path):
    """
    Save a pandas DataFrame to a CSV file.
    Parameters:
        df (pandas.DataFrame): The DataFrame to be saved.
        output_csv_path (str): The path to the output CSV file.
    Raises:
        IOError: If there is an error while writing the CSV file.
    """
    
    try:
        df.to_csv(output_csv_path, index=False, encoding='utf8')
    except IOError as e:
        print(f"Failed to write CSV file: {e}")

def main():
    input_path = Path(input_file_path) / input_file_name
    json_output_path = Path(output_path) / output_json_name
    csv_output_path = Path(output_path) / output_csv_name
    
    # De txt a diccionario
    file_dict = parse_file_to_dict(input_path)

    
    # Generando el JSON
    #write_json(file_dict, json_output_path)
    
    # De diccionario a DataFrame
    df = parse_dict_to_df(file_dict)
    
    # De DataFrame a CSV
    save_dataframe_to_csv(df, csv_output_path)

'''
*********************************************************************************************
APP
*********************************************************************************************
'''
if __name__ == "__main__":
    main()
   