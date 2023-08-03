public with sharing class FieldBindingHelper {
    private static sobject createObject(map<string,string>recordFieldWithValueMap, string objectApiName) {
        sObject obj = Schema.getGlobalDescribe().get(objectApiName).newSObject();
        Map<String, sObjectField> fields = obj.getSObjectType().getDescribe().fields.getMap();
         System.debug('obj'+obj);
         for(string key:recordFieldWithValueMap.keySet()){
            if(key!=null){
                DescribeFieldResult fieldInfo = fields.get(key).getDescribe();
            if(recordFieldWithValueMap.get(key)!=null){
                switch on (fieldInfo.getType()) {
                when id, address, combobox, email, encryptedstring, multipicklist, phone, picklist, reference, string, textarea, url {
                obj.put(key,recordFieldWithValueMap.get(key));
                }
                when Boolean {
                obj.put(key,Boolean.valueOf(recordFieldWithValueMap.get(key)));
                }
                when Date {
                obj.put(key,Date.valueOf(recordFieldWithValueMap.get(key)));
                }
                when DateTime {
                obj.put(key,DateTime.valueOf(recordFieldWithValueMap.get(key)));
                }
                when currency, double, percent {
                    System.debug('Double : '+fieldInfo.getType());
                    System.debug('Double : '+recordFieldWithValueMap.get(key));
                    if(recordFieldWithValueMap.get(key)!=''){
                        obj.put(key,Double.valueOf(recordFieldWithValueMap.get(key)));
                    }else{
                        obj.put(key,0);
                    }
                }
                when integer {
                obj.put(key,Integer.valueOf(recordFieldWithValueMap.get(key)));
                }
                when long {
                obj.put(key,recordFieldWithValueMap.get(key));
                }
            }
                }else{
                    obj.put(key,recordFieldWithValueMap.get(key));
                }
            }
        }
        System.debug(obj);
        return obj;
    }
    // public static map<string,string> recordValueMap(map<string,string> objectFieldWithFieldNameMap,map<string,string> userFieldWithValueMap){
    //     map<string,string> fieldValueMap=new map<string,string>();
    //     for(string key:userFieldWithValueMap.keySet()){
    //         fieldValueMap.put(objectFieldWithFieldNameMap.get(key), userFieldWithValueMap(key));
    //     }
    //     return fieldValueMap;
    // }
    public static  map<string,string> objectFieldWithFieldNameMap(){
        map<string,string> fieldMap=new map<string,string>();
            fieldMap.put('FieldName', 'SalesforceFieldName');
            return fieldMap;
    }
}