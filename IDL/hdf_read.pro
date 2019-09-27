

pro hdf_read

  ; Path to HDF File
  file_prefix = "C:\Users\cmcmahon\Documents\HLS_Data\11SMS\2017\S30\"
  file_name = "HLS.S30.T11SMS.2017104.v1.4.hdf"
  
  ; Open file
  file_id = HDF_SD_Start(file_prefix+file_name, /read)
  print,'Opened file ',file_prefix+file_name
  ; Extract number of datasets and attributes in file
  HDF_SD_FileInfo, file_id, num_datasets, num_attributes
  print,'File Contains ',num_datasets,' datasets and ',num_attributes,' attributes.'
  
  ; Read out information about each attribute
  for i=0, num_attributes-1 do begin
    HDF_SD_AttrInfo, file_id, i, name=attr_name, data=attr_data
    print,'  Attribute ',i,' - ',attr_name;,': ',attr_data
  endD
  
  ; Iterate over datasets, save each to an output tif raster
  print,'Beginning to read and print out data, band by band.'
  for i=0, num_datasets-1 do begin
    dataset_id = HDF_SD_Select(file_id,i)
    HDF_SD_GetData,dataset_id,current_band
    write_tiff,file_prefix+file_name+"_band_"+STRTRIM(string(i),1)+".tif",current_band
    print,'Printed band number ',i
  end
  
end