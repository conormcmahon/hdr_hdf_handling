
; *** HDR_TO_TIF ***
; Takes an input list of source MESMA output images in .HDR raster format
; Outputs falsecolor .TIF files with R=NPV, G=GV, B=Soil
; * Arguments *
;    --
; * Outputs *
;    --

pro hdr_to_tif

  ; Control file containing instructions for image processing
  close,1
  openr,1,"E:\cmcmahon\SERDP\Sarah_Shivers_Postanalysis\MESMA_falsecolors\image_list_HLS.txt"
  ; Directory where source images are stored
  input_filepath_prefix = strarr(1)
  readf,1,input_filepath_prefix
  ; Number of target raster images to be processed
  num_files = fltarr(1)
  readf,1,num_files
  ; Image Cropping Range 
  s_range = fltarr(2)  ; range in Scans (raster X)
  l_range = fltarr(2)  ; range in Lines (raster Y)
  readf,1,s_range
  readf,1,l_range
  ; List of Input Files where MESMA results are stored
  filenames = strarr(num_files)
  readf,1,filenames ; read list of filenames in from file
  close,1
  ; Debugging
  print,input_filepath_prefix + filenames
  
  ns_c = s_range[1] - s_range[0] + 1
  nl_c = l_range[1] - l_range[0] + 1
  ; input file with MESMA results (7 bands - GV,NPV,Soil,Shade,RMSE,Complexity,Model#)
  ;input_mesma_image = fltarr(ns,7,nl)
  ; output file with falsecolor display (3 bands - NPV,GV,Soil for RGB)
  transposed_falsecolor_image = fltarr(ns_c,3,nl_c)
  output_falsecolor_image = fltarr(3,ns_c,nl_c)
  
  ; iterate over input rasters
  for i=0, num_files[0]-1 do begin
    ; read in hdr binary file
    open_hdr,input_filepath_prefix + filenames[i],2,input_mesma_image,ns,nl
        
    ; build falsecolor matrix from input hdr file
    transposed_falsecolor_image[*,0,*] = input_mesma_image[s_range[0]:s_range[1],1,l_range[0]:l_range[1]]*255  ; Populate Red   with MESMA NPV values
    transposed_falsecolor_image[*,1,*] = input_mesma_image[s_range[0]:s_range[1],0,l_range[0]:l_range[1]]*255  ; Populate Green with MESMA GV values
    transposed_falsecolor_image[*,2,*] = input_mesma_image[s_range[0]:s_range[1],2,l_range[0]:l_range[1]]*255  ; Populate Blue  with MESMA Soil values
    close,2
        
    ; re-order dimensions to fit with TIF output structure (bands,X,Y from X,bands,Y)
    output_falsecolor_image = transpose(transposed_falsecolor_image,[1,0,2])
    ; output TIF image
    write_tiff,"E:\cmcmahon\SERDP\Sarah_Shivers_Postanalysis\MESMA_falsecolors\" + filenames[i] + ".tif",output_falsecolor_image
    print,string(i) + "th image has been processed! Source contained ", string(ns), " scans and ", string(nl), " lines."

  endfor  ; iterated over input rasters
  
end

