CStruct subclass: ObjcType [
    <declaration: #((#value #long))>
]

Object subclass: ObjcRuntime [

    ObjcRuntime class [
	
	at: aClassName [
	    | nsClass |
	    nsClass := self objcGetClass: aClassName.
	    ^ObjcClass fromPtr: nsClass
	]

	objcGetClass: name [
	    <category: 'class'>
	    <cCall: 'objc_getClass' returning: #cObject args: #( #string )>
	]

	objectGetClass: id [
	    <category: 'instance'>
	    <cCall:'object_getClass' returning: #cObject args: #( #cObject )>
	]
    
	classCreateInstance: aClass size: anInt [
	    <category: 'class'>
	    ^self primCreateInstance: aClass size: anInt zone: 0
	]

        primCreateInstance: aClass size: anInt zone: default [
	    <category: 'private class'>
	    <cCall: 'NSAllocateObject'  returning: #cObject args: #( #cObject #int #int)>
	]
    
	selGetUid: name [
	    <category: 'runtime query'>
	    <cCall: 'sel_getUid' returning: #cObject args: #( #string )>
	]

    	selGetName: name [
	    <category: 'runtime query'>
	    <cCall: 'sel_getName' returning: #symbol args: #( #cObject )>
	]
    
	primObjcGetClassList: buffer size: length [
	    <category: 'runtime query'>
	    <cCall: 'objc_getClassList' returning: #int args: #(#cObject #int)>
	]

	classGetName: aClass [
	    <category: 'class'>
	    <cCall: 'class_getName' returning: #string args: #( #cObject )>
	]

	classGetSuperclass: aClass [
	    <category: 'class'>
	    <cCall: 'class_getSuperclass' returning: #cObject args: #(#cObject)>
	]

	objcMsgSend: receiver sel: selector argc: aInt argv: args super: class returning: buffer [
	    <category: 'instance'>
	    <cCall: 'objc_sendMsg' returning: #void args: #( #cObject #cObject #int #smalltalk #cObject #byteArrayOut )>
	]

    	objcMsgReturnType: receiver sel: selector [
	    <cCall: 'objc_sendReturnLength' returning: #string args: #( #cObject #cObject )>
	]
	
	retain: receiver [
	    <category: 'instance'>
	    <cCall: 'objc_retain' returning: #void args: #( #cObject )>
	]

	release: receiver [
	    <category: 'instance'>
	    <cCall: 'objc_release' returning: #void args: #( #cObject )>
	]

	log: nsString [
	    <category: 'instance'>
	    <cCall: 'NSLog' returning: #void args: #( #cObject )>
	]

	log: nsString with: arg [
	    <category: 'instance'>
	    <cCall: 'NSLog' returning: #void args: #( #cObject #cObject )>
	]

	logObject: object [
	    <category: 'instance'>
	    | str |
	    str := NSString stringWithUTF8String: '%@'.
	    self log: str objcPtr with: object
	]

	primObjcAllocateClassPairSuper: aSuperClass name: aName indexable: aInt [
	    <cCall: 'objc_allocateClassPair' returning: #cObject args: #( #cObject #string #int )>
	]

	primObjcRegisterClassPair: aClass [
	    <cCall: 'objc_registerClassPair' returning: #void args: #( #cObject)>
	]

	objcRegisterClassPair: aClass [
	    self primObjcRegisterClassPair: aClass objcPtr
	]

	objcMakeSmalltalk: aClass [
	    <cCall: 'objc_makeSmalltalk' returning: #void args: #(#cObject)>
	]

	objcInstallSuspendLoop [
	    <cCall: 'objc_installSuspendLoop' returning: #void args: #()>
	]

	objcInstallEventLoop [
	    <cCall: 'objc_installEventLoop' returning: #void args: #()>
	]

	objcAllocateClassPairSuper: aSuperName name: aName indexable: aInt [
	    | class |
	    class := ObjcClass fromPtr: (self primObjcAllocateClassPairSuper: (self at: aSuperName) objcPtr name: aName indexable: aInt).
	    self objcMakeSmalltalk: class objcPtr.
	    ^class
	]

	objcAddStObjectGetter: class [
	    self primObjcAddStObjectGetter: class objcPtr
	]

	primObjcAddStObjectGetter: class [
	    <cCall: 'objc_addStObjectGetter' returning: #void args: #(#cObject)>
	]

	objcAddSetter: iVarName selector: sel inClass: class type: type [
	    self primObjcAddSetter: iVarName selector: sel inClass: class objcPtr type: type objcTypeStr
	]

	primObjcAddSetter: iVarName selector: sel inClass: class type: typeStr [
	    <cCall: 'objc_addSetter' returning: #void args: #(#string #string #cObject #string)>
	]

	objcAddGetter: iVarName selector: sel inClass: class type: type [
	    self primObjcAddGetter: iVarName selector: sel inClass: class objcPtr type: type objcTypeStr
	]

	primObjcAddGetter: iVarName selector: sel inClass: class type: typeStr [
	    <cCall: 'objc_addGetter' returning: #void args: #(#string #string #cObject #string)>
	]

	classAddIvar: class name: name type: type [
	    self primClassAddIvar: class objcPtr 
		 name: name 
		 size: type sizeof
		 alignment: (Character value: type logAlignof)
		 type: type objcTypeStr
	]

	primClassAddIvar: class name: name size: size alignment: align type: typstr [
	    <cCall: 'class_addIvar' returning: #uint args: #(#cObject #string #uInt #uchar #string)>
	]

	objcGetClassList [
	    | bufferType classes buffer |
	    bufferType := CArrayCType elementType: (CObjectType ptrType) 
		numberOfElements: self objcGetClassCount.
	    buffer := bufferType gcNew.
	    self primObjcGetClassList: buffer size: bufferType numberOfElements.
	    classes := OrderedCollection new.
	    0 to: bufferType numberOfElements - 1 do: [ :index |
		classes add: (buffer at: index)
	    ].
	    ^classes
	]
    
	objcGetClassCount [
	    ^self primObjcGetClassList: nil size: 0
	]
    ]

]

