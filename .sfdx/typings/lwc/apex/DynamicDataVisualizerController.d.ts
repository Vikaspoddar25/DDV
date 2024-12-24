declare module "@salesforce/apex/DynamicDataVisualizerController.getAllObjects" {
  export default function getAllObjects(): Promise<any>;
}
declare module "@salesforce/apex/DynamicDataVisualizerController.getParentObjectSchema" {
  export default function getParentObjectSchema(param: {objectName: any}): Promise<any>;
}
declare module "@salesforce/apex/DynamicDataVisualizerController.getChildObjectSchema" {
  export default function getChildObjectSchema(param: {objName: any}): Promise<any>;
}
declare module "@salesforce/apex/DynamicDataVisualizerController.getPicklistValues" {
  export default function getPicklistValues(param: {objName: any, fieldName: any}): Promise<any>;
}
declare module "@salesforce/apex/DynamicDataVisualizerController.getRecordDetails" {
  export default function getRecordDetails(param: {settings: any, recordId: any}): Promise<any>;
}
