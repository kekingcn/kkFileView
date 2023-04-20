class DICOMZero {
  constructor(options={}) {
    this.status = options.status || function() {};
    this.reset();
  }

  reset() {
    this.mappingLog = [];
    this.dataTransfer = undefined;
    this.datasets = [];
    this.readers = [];
    this.arrayBuffers = [];
    this.files = [];
    this.fileIndex = 0;
    this.context = {patients: []};
  }

  static datasetFromArrayBuffer(arrayBuffer) {
    let dicomData = dcmjs.data.DicomMessage.readFile(arrayBuffer);
    let dataset = dcmjs.data.DicomMetaDictionary.naturalizeDataset(dicomData.dict);
    dataset._meta = dcmjs.data.DicomMetaDictionary.namifyDataset(dicomData.meta);
    return(dataset);
  }

  // return a function to use as the 'onload' callback for the file reader.
  // The function takes a progress event argument and it knows (from this class instance)
  // when all files have been read so it can invoke the doneCallback when all
  // have been read.
  getReadDICOMFunction(doneCallback, statusCallback) {
    statusCallback = statusCallback || console.log;
    return progressEvent => {
      let reader = progressEvent.target;
      let arrayBuffer = reader.result;
      this.arrayBuffers.push(arrayBuffer);

      let dicomData;
      try {
        dicomData = dcmjs.data.DicomMessage.readFile(arrayBuffer);
        let dataset = dcmjs.data.DicomMetaDictionary.naturalizeDataset(dicomData.dict);
        dataset._meta = dcmjs.data.DicomMetaDictionary.namifyDataset(dicomData.meta);
        this.datasets.push(dataset);
      } catch (error) {
        console.error(error);
        statusCallback("skipping non-dicom file");
      }

      let readerIndex = this.readers.indexOf(reader);
      if (readerIndex < 0) {
        reject("Logic error: Unexpected reader!");
      } else {
        this.readers.splice(readerIndex, 1); // remove the reader
      }

      if (this.fileIndex === this.dataTransfer.files.length) {
        statusCallback(`Normalizing...`);
        try {
          this.multiframe = dcmjs.normalizers.Normalizer.normalizeToDataset(this.datasets);
        } catch (e) {
          console.error('Could not convert to multiframe');
          console.error(e);
        }
		
		if (this.multiframe.SOPClassUID == dcmjs.data.DicomMetaDictionary.sopClassUIDsByName['Segmentation']){
			statusCallback(`Creating segmentation...`);
			try {
			  this.seg = new dcmjs.derivations.Segmentation([this.multiframe]);
			  statusCallback(`Created ${this.multiframe.NumberOfFrames} frame multiframe object and segmentation.`);
			} catch (e) {
			  console.error('Could not create segmentation');
			  console.error(e);
			}
	    } else if (this.multiframe.SOPClassUID == dcmjs.data.DicomMetaDictionary.sopClassUIDsByName['ParametricMapStorage']){
			statusCallback(`Creating parametric map...`);
			try {
			  this.pm = new dcmjs.derivations.ParametricMap([this.multiframe]);
			  statusCallback(`Created ${this.multiframe.NumberOfFrames} frame multiframe object and parametric map.`);
			} catch (e) {
			  console.error('Could not create parametric map');
			  console.error(e);
			}
		}
        doneCallback();
      } else {
        statusCallback(`Reading... (${this.fileIndex+1}).`);
        this.readOneFile(doneCallback, statusCallback);
      }
    };
  }

  // Used for file selection button or drop of file list
  readOneFile(doneCallback, statusCallback) {
    let file = this.dataTransfer.files[this.fileIndex];
    this.fileIndex++;

    let reader = new FileReader();
    reader.onload = this.getReadDICOMFunction(doneCallback, statusCallback);
    reader.readAsArrayBuffer(file);

    this.files.push(file);
    this.readers.push(reader);
  }

  handleDataTransferFileAsDataset(file, options={}) {
    options.doneCallback = options.doneCallback || function(){};

    let reader = new FileReader();
    reader.onload = (progressEvent) => {
      let dataset = DICOMZero.datasetFromArrayBuffer(reader.result);
      options.doneCallback(dataset);
    }
    reader.readAsArrayBuffer(file);
  }
  
  extractDatasetFromZipArrayBuffer(arrayBuffer) {
    this.status(`Extracting ${this.datasets.length} of ${this.expectedDICOMFileCount}...`);
    this.datasets.push(DICOMZero.datasetFromArrayBuffer(arrayBuffer));
    if (this.datasets.length == this.expectedDICOMFileCount) {
      this.status(`Finished extracting`);
      this.zipFinishCallback();
    }
  };

  handleZip(zip) {
    this.zip = zip;
    this.expectedDICOMFileCount = 0;
    Object.keys(zip.files).forEach(fileKey => {
      this.status(`Considering ${fileKey}...`);
      if (fileKey.endsWith('.dcm')) {
        this.expectedDICOMFileCount += 1;
        zip.files[fileKey].async('arraybuffer').then(this.extractDatasetFromZipArrayBuffer.bind(this));
      }
    });
  }

  extractFromZipArrayBuffer(arrayBuffer, finishCallback=function(){}) {
    this.zipFinishCallback = finishCallback;
    this.status("Extracting from zip...");
    JSZip.loadAsync(arrayBuffer)
    .then(this.handleZip.bind(this));
  }

  organizeDatasets() {
    this.datasets.forEach(dataset => {
      let patientName = dataset.PatientName;
      let studyTag = dataset.StudyDate + ": " + dataset.StudyDescription;
      let seriesTag = dataset.SeriesNumber + ": " + dataset.SeriesDescription;
      let patientNames = this.context.patients.map(patient => patient.name);
      let patientIndex = patientNames.indexOf(dataset.PatientName);
      if (patientIndex == -1) {
        this.context.patients.push({
          name: dataset.PatientName,
          id: this.context.patients.length,
          studies: {}
        });
      }
      let studyNames; // TODO - finish organizing
    });
  }
}
