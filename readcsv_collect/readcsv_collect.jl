using CSV
using DataFrames
using  PrettyTables

file_path = "data_with_classes.csv"
df = CSV.read(file_path, DataFrame)

global matclass1 = Array{Real}(undef, 0, ncol(df)-1)
global matclass2 = Array{Real}(undef, 0, ncol(df)-1)
global matclass3 = Array{Real}(undef, 0, ncol(df)-1)

for row in eachrow(df)
    global matclass1, matclass2, matclass3
    data = collect(row)[1:ncol(df)-1]'
    class = row.Class
    if (class==1)
        matclass1 = [matclass1; data]
    elseif (class==2)
        matclass2 = [matclass2; data]
    elseif (class==3)
        matclass3 = [matclass3; data]
    end
end
pretty_table(matclass1)
pretty_table(matclass2)
pretty_table(matclass3)