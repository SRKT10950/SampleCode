/**
 * @description       : Common apex method 
 * @author            : Sri Ram Kumar
 * @group             : 
 * @created Date      : 02-26-2023
 * @last modified on  : 02-26-2023
 * @last modified by  : Sri Ram Kumar
**/
public without sharing class UtilityClass {

    /**
    * @description It will create the records of the apex error log. To track the error details.
    * Object Name Apex og Detail 
    * @author Sri Ram Kumar | 02-26-2023 
    * @param ex 
    * @return Apex_Log_Detail__c
    * @Exapmle Apex_Log_Detail__c apexLogObj = Utility.apexLog(error);
    * Insert as system apexLogObj
    **/
    public static Apex_Log_Detail__c apexlog(exception ex) {
         Apex_Log_Detail__c apexLogObj=new Apex_Log_Detail__c();
        try {
             if(ex!=null){
            apexLogObj.recordId__c=ex.getMessage().substringAfter('with id').substringBefore(';');
            apexLogObj.ClassName__c=ex.getStackTraceString().substringAfter('Class.').substringBefore('.');
            apexLogObj.methodName__c=ex.getStackTraceString().substringBefore(':').substringAfter('.').substringAfter('.');
            apexLogObj.errorMessage__c=ex.getMessage().substringBefore('.');
            apexLogObj.Description__c=ex.getStackTraceString()+'\n\n'+ex.getMessage();
            apexLogObj.Line_Number__c=ex.getLineNumber();
            apexLogObj.Type__c=ex.getTypeName();           
        }
        } catch (Exception expt) {
            apexLogObj.Description__c=ex.getStackTraceString()+'\n\n'+ex.getMessage();
        }
        Return apexLogObj;
    }
}