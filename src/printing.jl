include("./label_generator.jl")


main_file = "./culture_labels_09_17_2025.pdf"
if isfile(main_file)
    rm(main_file)
end

data = CSV.read("./culture_print_09_17_2025.csv",DataFrame)

n = nrow(data) 
for i in 1:n 
    if data[i,"Count"] > 0 
    f = microplate_labels("./",string(data[i,"Name"]),string(data[i,"ATCC"]),data[i,"Count"])
    append_pdf!(main_file,f,cleanup=true)
    end
end 


#=
main_file = "./cryo_labels_12_02_2025.pdf"
if isfile(main_file)
    rm(main_file)
end

data = CSV.read("./cryo_labels.csv",DataFrame)

n = nrow(data) 
for i in 1:n 
    n = data[i,"Count"]
    if n > 0 
    f = cryotube_labels("./",n, string.(collect(data[i,1:end-1]))...)
    append_pdf!(main_file,f,cleanup=true)
    end
end 
=#
