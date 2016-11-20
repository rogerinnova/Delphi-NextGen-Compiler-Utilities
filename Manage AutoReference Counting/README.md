#Monitor Object Lifetimes Under AUTREFCOUNT


AutoRefCount is mandatory with the new generation compiler, this theoretically removes the obligation and necessity of managing object lifetimes.  ( http://docwiki.embarcadero.com/RADStudio/Seattle/en/Automatic_Reference_Counting_in_Delphi_Mobile_Compilers )
However for any system which has any sort of complex object relationships this does not work and the task of making sure objects are freed becomes more difficult with ARC than without it. More details http://delphinotes.innovasolutions.com.au/posts/checking-object-lifetimes-with-autorefcount


The Module ISObjectCounter.Pas in this directory offers a number of functions to help manage your object lifetimes and track unreleased objects.

- Procedure IncObjectCount(AObj: Pointer);
- Procedure DecObjectCount(AObj: Pointer);
- Function CurrentObjectCount: Integer;
= Function ObjectCountWithReset: Integer; //Testing
- Procedure TrackObjectTypes;
- Function ReportObjectTypes: TCtrReportArray;
- Function ObjectTypesAsString: String;
- Procedure DisposeOfAndNil(Var AObj:TObject);
- Function DecodeInDispose(AObj:TObject):Boolean;
- Function DecodeAfterDispose(AObj:TObject):Boolean;
- Function DecodeRefCount(AObj:TObject):Integer;


