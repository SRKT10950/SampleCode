/**
 * @description       : Common apex method
 * @author            : Sri Ram Kumar
 * @group             :
 * @created Date      : 02-26-2023
 * @last modified on  : 02-26-2023
 * @last modified by  : Sri Ram Kumar
**/
public without sharing class UtilityClass {

    private static final String[] ones = new String[]{'', 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine'};
    private static final String[] teens = new String[]{'', 'eleven', 'twelve', 'thirteen', 'fourteen', 'fifteen', 'sixteen', 'seventeen', 'eighteen', 'nineteen'};
    private static final String[] tens = new String[]{'', 'ten', 'twenty', 'thirty', 'forty', 'fifty', 'sixty', 'seventy', 'eighty', 'ninety'};
    private static final String[] internationalDenominations = new String[]{'', 'thousand', 'million', 'billion', 'trillion', 'quadrillion', 'quintillion'};
    private static final String[] indianDenominations = new String[]{'', 'thousand', 'lakh', 'crore'};


    /**
    * @description It will create the records of the apex error log. To track the error details.
    * Object Name Apex og Detail
    * @author Sri Ram Kumar | 02-26-2023
    * @param ex
    * @return Error_Log__c
    * @Exapmle Error_Log__c arrorLogObj = Utility.apexLog(error);
    * Insert as system arrorLogObj
    **/
    public static Error_Log__c apexlog(exception ex) {
         Error_Log__c errorLogObj=new Error_Log__c();
        try {
             if(ex!=null){
            errorLogObj.recordId__c=ex.getMessage().substringAfter('with id').substringBefore(';');
            errorLogObj.ClassName__c=ex.getStackTraceString().substringAfter('Class.').substringBefore('.');
            errorLogObj.methodName__c=ex.getStackTraceString().substringBefore(':').substringAfter('.').substringAfter('.');
            errorLogObj.errorMessage__c=ex.getMessage().substringBefore('.');
            errorLogObj.Description__c=ex.getStackTraceString()+'\n\n'+ex.getMessage();
            errorLogObj.Line_Number__c=ex.getLineNumber();
            errorLogObj.Type__c=ex.getTypeName();
        }
        } catch (Exception expt) {
            errorLogObj.Description__c=ex.getStackTraceString()+'\n\n'+ex.getMessage();
        }
        Return errorLogObj;
    }
    /**
     * Creates an sObject with the given record field values and object API name.
     * @param mapFieldWithValue A map of record field names and their corresponding values.
     * @param objectApiName The API name of the sObject to create.
     * @return The created sObject.
     */
    private static sobject createObject(map<string,string>mapFieldWithValue, string objectApiName) {
        sObject obj = Schema.getGlobalDescribe().get(objectApiName).newSObject();
        Map<String, sObjectField> fields = obj.getSObjectType().getDescribe().fields.getMap();
         System.debug('obj'+obj);
         for(string key:mapFieldWithValue.keySet()){
            if(key!=null){
                DescribeFieldResult fieldInfo = fields.get(key).getDescribe();
            if(mapFieldWithValue.get(key)!=null){
                switch on (fieldInfo.getType()) {
                when id, address, combobox, email, encryptedstring, multipicklist, phone, picklist, reference, string, textarea, url {
                obj.put(key,mapFieldWithValue.get(key));
                }
                when Boolean {
                obj.put(key,Boolean.valueOf(mapFieldWithValue.get(key)));
                }
                when Date {
                obj.put(key,Date.valueOf(mapFieldWithValue.get(key)));
                }
                when DateTime {
                obj.put(key,DateTime.valueOf(mapFieldWithValue.get(key)));
                }
                when currency, double, percent {
                    System.debug('Double : '+fieldInfo.getType());
                    System.debug('Double : '+mapFieldWithValue.get(key));
                    if(mapFieldWithValue.get(key)!=''){
                        obj.put(key,Double.valueOf(mapFieldWithValue.get(key)));
                    }else{
                        obj.put(key,0);
                    }
                }
                when integer {
                obj.put(key,Integer.valueOf(mapFieldWithValue.get(key)));
                }
                when long {
                obj.put(key,mapFieldWithValue.get(key));
                }
            }
                }else{
                    obj.put(key,mapFieldWithValue.get(key));
                }
            }
        }
        System.debug(obj);
        return obj;
    }

    public static String convertNumberToIndianCurrency(Integer intNum) {
        if (intNum == 0) {
            return 'zero';
        }

        String result = '';
        Integer chunkCount = 0;

        while (intNum > 0) {
            if (Math.Mod(intNum,1000) != 0) {
                String chunkInWords = convertChunkToWords(Math.Mod(intNum,1000));
                if (chunkCount > 0) {
                    chunkInWords += ' ' + indianDenominations[chunkCount];
                }
                result = chunkInWords + ' ' + result;
            }
            intNum /= 1000;
            chunkCount++;
        }

        return result.trim();
    }

    private static String convertChunkToWords(Integer intNum) {
        String chunkInWords = '';

        // Convert hundreds place
        if (intNum >= 100) {
            chunkInWords += ones[intNum / 100] + ' hundred';
           intNum= Math.Mod(intNum,100);
        }

        // Convert tens and ones place
        if (intNum >= 20) {
            chunkInWords += ' ' + tens[intNum / 10];
          intNum= Math.Mod(intNum,10);
        } else if (intNum > 10) {
            chunkInWords += ' ' + teens[intNum - 10];
            intNum = 0;
        }

        // Convert ones place
        if (intNum > 0) {
            chunkInWords += ' ' + ones[intNum];
        }

        return chunkInWords.trim();
    }
    // International currency denominations
    public static String convertNumberToInternationalCurrency(Integer intNum) {
        if (intNum == 0) {
            return 'zero';
        }

        String result = '';
        Integer chunkCount = 0;

        while (intNum > 0) {
            if (Math.Mod(intNum,1000) != 0) {
                String chunkInWords = convertChunkToWords(Math.Mod(intNum,1000));
                if (chunkCount > 0) {
                    chunkInWords += ' ' + internationalDenominations[chunkCount];
                }
                result = chunkInWords + ' ' + result;
            }
            intNum /= 1000;
            chunkCount++;
        }

        return result.trim();
    }
}