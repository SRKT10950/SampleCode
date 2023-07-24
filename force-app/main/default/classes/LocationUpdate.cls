public with sharing class LocationUpdate {
    @AuraEnabled
    public static  void updatLocation(Decimal latitude, Decimal longitude, String recordId){
        try {

            Visit_Plans__c accloc=[SELECT Geolocation__Longitude__s, Geolocation__Latitude__s, Check_In_Date_Time__c FROM Visit_Plans__c WHERE Id=:recordId];
            system.debug(accloc);
            accloc.Geolocation__Latitude__s=latitude;
        accloc.Geolocation__Longitude__s=longitude;
        accloc.Check_In_Date_Time__c= Datetime.now();
        update accloc;
        system.debug(recordId);
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
}