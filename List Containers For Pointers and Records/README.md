#TList and TStrings Derivatives Under AUTREFCOUNT


Until the introduction of Auto Reference Counting in the Delphi NextGen compiler object references and memory pointers were interchangeable so that a TList, a TStringList and a TObjectList would store references to an object, a record, a class Type or a simple memory reference. 

Of course in the case of both records and objects the memory management fell to the programmer and the OwnsObjects flag should not be set if objects are not in the store. As long as one was careful with 64 bit compiles a simple integer was also happily accommodated.    

While these principles worked well before Auto Reference Counting porting any code using them to a mobile environment was challenging. Any allocation to an "object" variable now calls TObject.__ObjAddRef and will raise an exception if the pointer does not reference an actual object in memory. Similarly if an Object is no longer assigned to an object reference it will be destroyed even if a reference is held in a pointer somewhere. 

The Module ISListCnters.Pas in this directory offers a number of Containers which will let you store class types, records and miscellaneus memory pointers in Tstrings derivatives and enables you to persist Objects in a List container containing pointers.

#More Details
http://delphinotes.innovasolutions.com.au/posts/under-autorefcount-pointers-records-and-integers-clash-with-object-properties


#Summary
I use three containers

##TISObjList = class(TList)

Accepts and delivers pointers in default Items[] property but manages the reference counting so objects inserted are not "Recovered" by ARC while they are contained.

## TISStringPtrList = class(TStrings)
A copy of TStringList Code but with the default Objects[] property defined as a pointer this means AddObject can accept Objects, Integers or Pointers without crashing ARC.

The reference count of "objects" is not managed so Object Life Times must be maintaioned else where.


##TIsIntPtrStrings = class(TStringList)

Has its own internal object structure enabling properties of Objects[] Pointers[] and Integers[] and (String,Item) Methods of AddObject, AddPointer and AddInteger

Because the actual stored items are objects containing the Integers or pointers TStrings.AddStrings works fine and it can be passed to components such as list boxes etc to select or sort items based on the "string" representation but the associated integer or pointer can be referenced from the index once the string is selected.

