import pandas

file_path = "data_with_classes.csv"
df = pandas.read_csv(file_path)

matclass1 = df[df["Class"]==1].reset_index(drop=True)
matclass2 = df[df["Class"]==2].reset_index(drop=True)
matclass3 = df[df["Class"]==3].reset_index(drop=True)

matclass1.pop("Class")
matclass2.pop("Class")
matclass3.pop("Class")

print(matclass1)
print(matclass2)
print(matclass3)