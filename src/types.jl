
"""
    PlateTag 

Abstract supertype for all PlateTag labels (eg, MicroTag, CryoTag, BottleTag, etc.)
"""
abstract type PlateTag end 


## Constants for all PlateTag objects 
const platetag_font= "Courier Bold" 
const platetag_fontsize = 18


"""
    MicroTag <: PlateTag

PlateTag label for microplates. The standard MicroTag design has room for two lines of text and and optional date field. 

Dimensions: 
height: 0.25 inches 
width: 2 inches 
"""
struct MicroTag <: PlateTag 
    line1::AbstractString 
    line2::AbstractString 
    qr::Union{Nothing,QRCoders.QRCode}
    date_field::Bool 
    font::AbstractString 
    fontsize::Integer
    MicroTag(line1,line2,qr=nothing;date_field=true,font=platetag_font,fontsize=platetag_fontsize) =
    new(line1,line2,qr,date_field,font,fontsize)
end 

"""
    CryoTag <: PlateTag

PlateTag label for microplates. The standard CryoTag design has room for five lines of text. 
    If optional date field and QR codes are added, they will take the place of the last line

Dimensions: 
height: 0.75 inches 
width: 1.5 inches 
"""
struct CryoTag <: PlateTag 
    lines::Vector{<:AbstractString} 
    qr::Union{Nothing,QRCoders.QRCode}
    date_field::Bool 
    font::AbstractString 
    fontsize::Integer
    function CryoTag(lines,qr=nothing;date_field=true,font=platetag_font,fontsize=platetag_fontsize) 
        max_lines = 7
        if  date_field # if either of these fields are present, then they take the place of the last line 
            max_lines -= 1 
            if !isnothing(qr)
                max_lines -= 1 
            end
        elseif !isnothing(qr) 
            max_lines -=2
        end 
        if length(lines) > max_lines
            @warn("CryoTags can have a maximum of $max_lines lines with these features")
        end
        
        return new(lines[1:(min(length(lines),max_lines))],qr,date_field,font,fontsize)
    end
end 



"""
    CryoTag <: PlateTag

PlateTag Label for bottels and tubes. The standard BottleTag is a two part label with matching QR codes and space for lines of text. 
    If optional date field is added, it takes the place of the last line of text

Dimensions: 
retangular 
height: 0.75 inches 
width: 1.5 inches 
circular 
diameter: 0.75 inches 
"""
struct BottleTag <: PlateTag 
    lines::Vector{<:AbstractString}
    qr::QRCoders.QRCode
    date_field::Bool
    font::AbstractString
    fontsize::Integer
    function BottleTag(lines,qr=QRCode(string(UUIDs.uuid4()));date_field=true,font=platetag_font,fontsize=platetag_fontsize) 
        max_lines = 7
        if  date_field # if either of these fields are present, then they take the place of the last line 
            max_lines -= 1 
        end 
        if length(lines) > max_lines
            @warn("BottleTags can have a maximum of $max_lines lines with these features")
        end
        
        return new(lines[1:(min(length(lines),max_lines))],qr,date_field,font,fontsize)
    end 
end 
    
    