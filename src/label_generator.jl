using Plots , PDFmerger, Measures, CSV, DataFrames,QRCoders,UUIDs 



function microplate_labels(dir::AbstractString, line1::AbstractString,line2::AbstractString, n::Integer)
    filename = "$(line1)_$(line2)_$n.pdf"

    out_file = joinpath(dir,filename) 

    for i in 1:n 

    plt = plot_microplate_label(line1,line2,300)

    savefig(plt,"tmp.pdf")

    append_pdf!(out_file,"tmp.pdf",cleanup=true)
    end 




    return out_file 


end 


function align_labels(dir::AbstractString, range::UnitRange{Int64})
    designator = "AL"

    filename = "align_plates_$(range[1])_$(range[end]).pdf"

    out_file = joinpath(dir,filename) 

    for i in range
        line1 = string(designator,lpad(string(i),5,"0"))
        line2=""


    plt = plot_microplate_label(line1,line2,300)

    savefig(plt,"tmp.pdf")

    append_pdf!(out_file,"tmp.pdf",cleanup=true)
    end 




    return out_file 


end 




function plot_microplate_label(line1::AbstractString,line2::AbstractString,dpi = 300)
    maxlen1 = 24
    maxlen2= 15
    line1plot = line1 
    line2plot=line2
    if length(line1plot) > maxlen1
        line1plot = string(line1plot[1:maxlen1-3],"...")
    end 

    if length(line2plot) > maxlen2 
        line2plot = string(line2plot[1:maxlen2-3],"...")
    end 

    textsize=18
    font="Courier Bold"
        wi = 1.5 
    hi = 0.25
    px = round(Int,wi *dpi)
    py = round(Int,hi *dpi)
    p = plot(size=(px,py), axis=nothing, showaxis=false,grid=false,legend=false, margin=(0,:mm)) 
    xlims!(0,1.5)
    ylims!(0,0.25)

    annotate!(0,0.25,text(line1plot,textsize,font, :left,:top))
    annotate!(0,0,text(line2plot,textsize,font,:left,:bottom))
    annotate!(1.5,0,text("__/__/__",textsize,font ,:right,:bottom))
    #plot!([1,1.5],[0.12,0.12],linewidth=2,color="black")
    




    return p 
end 

rectangle(w, h, x, y) = Shape(x .+ [0,w,w,0], y .+ [0,0,h,h])

function plot_qr!(p,qr::BitMatrix;ax=0,ay=0,px=0.25)
    d = max(size(qr)...)
    sqd = px/d

    for x in 1:size(qr)[2]
        for y in 1:size(qr)[1]
            if qr[y,x] 
            plot!(p,rectangle(sqd,sqd,x*sqd+ax,y*sqd+ay),color="black")
            end
        end 
    end 
end 


function plot_cryotube_label(lines::Vararg{<:AbstractString};maxlen=24,dpi = 300,textsize=16,font="Courier Bold",kwargs...)
    wi = 1.5 
    hi = 0.75
    lw = 0.1
    qrcode_size=0.25
    px = round(Int,wi *dpi)
    py = round(Int,hi *dpi)
    p = plot(size=(px,py), axis=nothing, showaxis=false,grid=false,legend=false, margin=(0,:mm)) 
    xlims!(0,wi)
    ylims!(0,hi)
    l = hi 
    for line in lines 
        if round(l,digits=2) < qrcode_size + lw
            @warn "lines exceeded the height of the label. line '$(line)' and any lines after will be omitted."
            break
        end 
        lineplot = line
        if length(lineplot) > maxlen
        lineplot = string(lineplot[1:maxlen-3],"...")
        end
        annotate!(0,l,text(lineplot,textsize,font, :left,:top))
        l -= lw 
    end 

    qr = qrcode(string(UUIDs.uuid4()))
    plot_qr!(p,qr)
    plot_qr!(p,qr;ax=0.75,px=qrcode_size)

    

    return p 
end 


function cryotube_labels(dir::AbstractString,n::Integer,lines::Vararg{<:AbstractString};kwargs...)
    filename = "labels.pdf"

    out_file = joinpath(dir,filename) 

    for i in 1:n 

    plt = plot_cryotube_label(lines;kwargs...)

    savefig(plt,"tmp.pdf")

    append_pdf!(out_file,"tmp.pdf",cleanup=true)
    end 




    return out_file 


end 

