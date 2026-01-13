
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

function plot(tag::MicroTag)
    wi = 1.5 
    hi = 0.25
    dpi = 600
    textsize= round(Int64,tag.fontsize * dpi /300)
    font = tag.font 
    linemax = 22
    if !isnothing(tag.qr) 
        linemax-= 4
    end 
    line1 = tag.line1
    line2=tag.line2
    if length(line1) > linemax 
        line1 = string(line1[1:linemax-3],"...")
    end 

    line2max = tag.date_field ? linemax -9 : linemax # shorten the max length of line2 if the date field is active

    if length(line2) > line2max
        line2 = string(line2[1:line2max-3],"...")
    end 
 


    qr_width=0.25
    date_x = isnothing(tag.qr) ? wi : wi - 1.25*qr_width
    px = round(Int,wi *dpi)
    py = round(Int,hi *dpi)
    p = plot(size=(px,py), axis=nothing, showaxis=false,grid=false,legend=false, margin=(0,:mm)) 
    xlims!(0,wi)
    ylims!(0,hi)

    annotate!(0,0.25,text(line1,textsize,font, :left,:top))
    annotate!(0,0,text(line2,textsize,font,:left,:bottom))
    if tag.date_field
        annotate!(date_x,0,text("__/__/__",textsize,font ,:right,:bottom))
    end 
    if !isnothing(tag.qr) 
        plot_qr!(p,qrcode(tag.qr);ax=wi-qr_width,ay=0,px=qr_width)
    end 
    #plot!([1,1.5],[0.12,0.12],linewidth=2,color="black"
    return p 
end 

function plot(tag::CryoTag)
    wi = 1.5 
    hi = 0.75
    dpi = 600
    textsize= round(Int64,tag.fontsize * dpi /300)-1
    font = tag.font 
    linemax = 21
    lw = 0.1 # width of each line

    px = round(Int,wi *dpi)
    py = round(Int,hi *dpi)
    p = plot(size=(px,py), axis=nothing, showaxis=false,grid=false,legend=false, margin=(0,:mm)) 
    xlims!(0,wi)
    ylims!(0,hi)
    l = hi 
    lines = tag.lines

    for line in lines 
        lineplot = line
        if length(lineplot) > linemax
        lineplot = string(lineplot[1:linemax-3],"...")
        end
        annotate!(0.05,l,text(lineplot,textsize,font, :left,:top))
        l -= lw 
    end 
    if tag.date_field
        date_x = 0.5
        annotate!(date_x,0,text("__/__/__",textsize,font ,:left,:bottom))
    end 
    if !isnothing(tag.qr) 
            qrcode_size=0.33
            qr = qrcode(tag.qr)
            plot_qr!(p,qr,ax=0.05,px=qrcode_size)
            plot_qr!(p,qr;ax=1,px=qrcode_size)
    end 

    

    return p 
end 


function plot(tag::BottleTag)
    wi = 2 + 1 + 0.125 # rect width, circle width , spacing buffer
    hi = 1
    dpi = 600
    textsize= round(Int64,tag.fontsize * dpi /300)-1
    font = tag.font 
    linemax = 18
    lw = 0.1 # width of each line
    cir = 0 
    rect = 1.125
    qrcode_size=0.6
    px = round(Int,wi *dpi)
    py = round(Int,hi *dpi)
    p = plot(size=(px,py), axis=nothing, showaxis=false,grid=false,legend=false, margin=(0,:mm)) 
    xlims!(0,wi)
    ylims!(0,hi)
    l = hi -.125
    lines = tag.lines

    for line in lines 
        lineplot = line
        if length(lineplot) > linemax
        lineplot = string(lineplot[1:linemax-3],"...")
        end
        annotate!(0.125 ,l,text(lineplot,textsize,font, :left,:top))
        l -= lw 
    end 
    if tag.date_field
        date_x = 0.125
        annotate!(date_x,0.125,text("__/__/__",textsize,font ,:left,:bottom))
    end  

    qr = qrcode(tag.qr)
    qr_match = qr_text_hash(tag.qr)
    cir_code_x = wi-qrcode_size-0.2 
    rect_code_x = 2-qrcode_size

    hash_text_size = 15

    annotate!(cir_code_x + qrcode_size/2,0.2, text(qr_match,hash_text_size,font,:center,:top))
    annotate!(rect_code_x+  qrcode_size/2,0.2, text(qr_match,hash_text_size,font,:center,:top))
    
    plot_qr!(p,qr;ax=cir_code_x,ay=0.2,px=qrcode_size)
    plot_qr!(p,qr;ax=rect_code_x  ,ay=0.2,px=qrcode_size)

    

    return p 
end 



"""
    qr_text_hash(code::QRCoders.QRCode;trunc::Integer=12,hypen_length=3) 

Hash a qr code and trim it to `trunc`. Return a hyphenated string of the hash
"""
function qr_text_hash(code::QRCoders.QRCode;trunc::Integer=12,hypen_length=3) 
    str = string(hash(code.message))[1:trunc]  # hash and truncate
    splitstr = [str[i:(min(i+hypen_length-1,end))] for i in 1:hypen_length:(length(str))]
    return join(splitstr,"-")
end 

