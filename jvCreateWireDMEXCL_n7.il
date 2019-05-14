procedure( jvCreateWireDMEXCL_Menu()

	command="jvCreateWireDMEXCL_Menu"
	jvLog()


prog((enclosure level dviaexcl group)

/*
net = hiCreateStringField(
        ?name `net
        ?prompt "Net Name"
	?defValue "nil"
        ?editable t
        )
*/

enclosure = hiCreateFloatField(
        ?name `enclosure
        ?prompt "DMEXCL Enclosure"
	?defValue 0.0
        ?editable t
        )
level = hiCreateCyclicField(
        ?name `level
        ?prompt "Add +/-"
        ?choices list("0" "1" "2" "ALL")
        ?value "1"
        )
dviaexcl = hiCreateBooleanButton(
	?name `dviaexcl
	?buttonText "DVIAEXCL"
	?value t
	)

group = hiCreateBooleanButton(
	?name `group
	?buttonText "Group"
	?value t
	)

/*
justification = hiCreateCyclicField(
        ?name `justification
        ?prompt "Justification	"
        ?choices list("lowerLeft" "centerLeft" "upperLeft" "lowerCenter" "centerCenter" "upperCenter" "lowerRight" "centerRight" "upperRight")
        ?value "centerCenter"
        )
*/



jvCreateWireDMEXCL_Menu_Form= hiCreateAppForm(
        ?name `jvCreate
        ?formTitle "Create Wire DMEXCL"
        ?callback 'jvCreateWireDMEXCL
        ?fields list(
                  ;list(net 0:0 120:10 70)
                  ;list(enclosure 0:30 185:20 130)
		  ;list(level 0:60 70:10 70)
		  ;list(justification 0:90 150:10 100)

		  ;list(net 0:0 120:10 70)
                  list(enclosure 0:0 185:20 130)
		  list(level 0:30 70:10 70)
		  ;list(dviaexcl 0:60 70:10 70)
		  ;list(group 0:80 70:10 70)


                );list
	;?help jvAbout()        
	?help list("kkkk" 'ttt)
        ?initialSize t
        ?unmapAfterCB t
        )
hiDisplayForm(jvCreateWireDMEXCL_Menu_Form)
);prog
);procedure









procedure( jvCreateWireDMEXCL(theForm)

prog( (enclosure level dviaexcl group)

	cv=geGetEditCellView()
	
	level=theForm->level->value
	enclosure=theForm->enclosure->value
	;dviaexcl=theForm->dviaexcl->value
	;group=theForm->group->value

	;level="0" ;0-1-2
	dviaexcl="nil"
	group="t"
	;enclosure=2
	
     foreach( wire geGetSelSet()
        if(wire~>objType=="stdVia"
           geDeselectFig(wire)
        );if
    );foreach

	
	foreach( wire geGetSelSet()
		if( rexMatchp("^V" car(wire~>lpp))
		geDeselectFig(wire)

		);if
	);foreach

    foreach( wire geGetSelSet()
        if(wire~>layerName=="AP"
           geDeselectFig(wire)
        );if
    );foreach



	foreach( wire geGetSelSet()
	
		if( wire~>purpose!="pin" then 
			genWire=dbCopyFig(wire cv)
			geDeselectFig(wire)		
			geSelectFig(genWire)		
		);if		

	);foreach

	jvConvertToPolygon()
	jvResizePolygon()
	;level="0" ;0-1-2
	;dviaexcl="t"
	;group="t"
	jvConvertToDMEXCL()
	;leHiMerge()
	jvGroupDMEXCL()
	
);prog
);procedure

procedure( jvConvertToPolygon()
	
	foreach( shape geGetSelSet()
		/*
		if(shape~>objType=="pathSeg" then
		dbConvertPathSegToPolygon(shape)
		else
		dbConvertPathToPolygon(shape)
		)
		*/
		
		leHiConvertShapeToPolygon()

	);foreach

);procedure

procedure( jvResizePolygon()

	foreach( shape geGetSelSet()
		leSizeShape(shape enclosure)
	);foreach	

);procedure

procedure( jvConvertToDMEXCL()
	
	/*
	foreach( shape geGetSelSet()
		shapeM=shape~>layerName
		shape~>lpp=list("DMEXCL" strcat("dummy" car(parseString(shape~>layerName "M"))))

		genShape=dbCopyFig(shape cv)
		genShape~>lpp=list("DVIAEXCL" strcat("dummy" car(parseString(shapeM "M"))))
		geSelectFig(genShape)
	);foreach
	*/

	case( level

		("ALL"
			foreach( shape geGetSelSet()
				shapeM=shape~>layerName
				shape~>lpp=list("DEXCL" "drawing")
				);foreach
		);0


		("0"
			foreach( shape geGetSelSet()
				shapeM=shape~>layerName
				shape~>lpp=list("DEXCL" strcat("m" car(parseString(shape~>layerName "M"))))
				if(dviaexcl=="t" then
				genShape=dbCopyFig(shape cv)
				genShape~>lpp=list("DEXCL" strcat("v" car(parseString(shapeM "M"))))
				geSelectFig(genShape)
				);if
			);foreach
		);0

		("1"
			foreach( shape geGetSelSet()
				shapeM=shape~>layerName
				shape~>lpp=list("DEXCL" strcat("m" car(parseString(shape~>layerName "M"))))
				if(dviaexcl=="t" then
				genShape=dbCopyFig(shape cv)
				genShape~>lpp=list("DEXCL" strcat("v" car(parseString(shapeM "M"))))
				geSelectFig(genShape)
				);if
				if(shapeM!="M15" then
                genShape1=dbCopyFig(shape cv)
				genShape1~>lpp=list("DEXCL" strcat("m" pcExprToString(int(aelNumber(car(parseString(shapeM "M")))+1))))
				geSelectFig(genShape1)
				if(dviaexcl=="t" then
				genShape2=dbCopyFig(shape cv)
				genShape2~>lpp=list("DEXCL" strcat("v" pcExprToString(int(aelNumber(car(parseString(shapeM "M")))+1))))
				geSelectFig(genShape2)
				);if
				)
                if(shapeM!="M0" then
				genShape3=dbCopyFig(shape cv)
				genShape3~>lpp=list("DEXCL" strcat("m" pcExprToString(int(aelNumber(car(parseString(shapeM "M")))-1))))
				geSelectFig(genShape3)
				if(dviaexcl=="t" then
				genShape4=dbCopyFig(shape cv)
				genShape4~>lpp=list("DEXCL" strcat("v" pcExprToString(int(aelNumber(car(parseString(shapeM "M")))-1))))
				geSelectFig(genShape4)
				);if
				)



			);foreach
		);1

		("2"
			foreach( shape geGetSelSet()
				shapeM=shape~>layerName
				shape~>lpp=list("DEXCL" strcat("m" car(parseString(shape~>layerName "M"))))
				if(dviaexcl=="t" then
				genShape=dbCopyFig(shape cv)
				genShape~>lpp=list("DEXCL" strcat("v" car(parseString(shapeM "M"))))
				geSelectFig(genShape)
				);if
				if(shapeM!="M15" then
                genShape1=dbCopyFig(shape cv)
				genShape1~>lpp=list("DEXCL" strcat("m" pcExprToString(int(aelNumber(car(parseString(shapeM "M")))+1))))
				geSelectFig(genShape1)
				if(dviaexcl=="t" then
				genShape2=dbCopyFig(shape cv)
				genShape2~>lpp=list("DEXCL" strcat("v" pcExprToString(int(aelNumber(car(parseString(shapeM "M")))+1))))
				geSelectFig(genShape2)
				);if
                )
				if(shapeM!="M0" then
				genShape3=dbCopyFig(shape cv)
				genShape3~>lpp=list("DEXCL" strcat("m" pcExprToString(int(aelNumber(car(parseString(shapeM "M")))-1))))
				geSelectFig(genShape3)
				if(dviaexcl=="t" then
				genShape4=dbCopyFig(shape cv)
				genShape4~>lpp=list("DEXCL" strcat("v" pcExprToString(int(aelNumber(car(parseString(shapeM "M")))-1))))
				geSelectFig(genShape4)
				);if
				)
				if(shapeM!="M14"&&shapeM!="M15" then
                genShape5=dbCopyFig(shape cv)
				genShape5~>lpp=list("DEXCL" strcat("m" pcExprToString(int(aelNumber(car(parseString(shapeM "M")))+2))))
				geSelectFig(genShape5)
				if(dviaexcl=="t" then
				genShape6=dbCopyFig(shape cv)
				genShape6~>lpp=list("DEXCL" strcat("v" pcExprToString(int(aelNumber(car(parseString(shapeM "M")))+2))))
				geSelectFig(genShape6)
				);if
				)
                if(shapeM!="M0"&&shapeM!="M1" then
				genShape7=dbCopyFig(shape cv)
				;printf("dmexcl-2")
				genShape7~>lpp=list("DEXCL" strcat("m" pcExprToString(int(aelNumber(car(parseString(shapeM "M")))-2))))
				geSelectFig(genShape7)
				if(dviaexcl=="t" then
				genShape8=dbCopyFig(shape cv)
				genShape8~>lpp=list("DEXCL" strcat("v" pcExprToString(int(aelNumber(car(parseString(shapeM "M")))-2))))
				geSelectFig(genShape8)
				);if
				)



			);foreach
		);2



	);case	

);procedure

procedure( jvGroupDMEXCL()

	if(group=="t" then
	
	;dbCreateGroup(geGetSelSet() "DMEXCL_gen")	
	;leGroupForm->groupName->value="dummy"
	leHiCreateGroup()
	;_leGenerateFigGroup()

	);if	

);procedure



procedure( jvLog()

x=geGetEditCellView()
;command="test"
time=getCurrentTime()
;pwd
library=x~>libName
cell=x~>cellName
view=x~>viewName

procedure( jvWhoAmI()
system("whoami > myName")
      let(( inPort nextLine)
        inPort = infile( "./myName")
        when( inPort
          while( gets( nextLine inPort)
         printf("%s" nextLine)

	 myName=nextLine	

          )
      close( inPort)
          )
         )
     )

procedure( jvPwd()
system("pwd > myPath")
      let(( inPort nextLine)
        inPort = infile( "./myPath")
        when( inPort
          while( gets( nextLine inPort)
         printf("%s" nextLine)

	 myPath=nextLine	

          )
      close( inPort)
          )
         )
     )
jvWhoAmI()
jvPwd()


newChar=pcreCompile("\n")
colon=pcreCompile(":")
space=pcreCompile(" ")
myName=pcreReplace(newChar myName "" 0) ;remove the newChar
myPath=pcreReplace(newChar myPath "" 0) ;remove the newChar
myTime=pcreReplace(colon time "" 0) ;remove the colon in time
myTime2=pcreReplace(space myTime "" 0) ;remove the spaces in time

myFile = strcat(command "_" myTime2 "_" myName)
myPort = outfile(strcat("/home/jviray/tmp/" myFile))
fprintf(myPort "************************************************************\n\n")
fprintf(myPort strcat(myName "\n"))
fprintf(myPort strcat(myPath "\n"))
fprintf(myPort strcat(time "\n"))
fprintf(myPort strcat(command "\n"))
fprintf(myPort strcat(library "\n"))
fprintf(myPort strcat(cell "\n"))
fprintf(myPort strcat(view "\n"))
fprintf(myPort strcat(" " "\n"))
close(myPort)

)


procedure(jvWarningMessage()
        hiDisplayAppDBox(
                ?name `test
                ?dialogType hicMessageDialog
                ?dboxBanner "Reminder"
                ?dboxText strcat("Warning! No cell has been selected.")
                ?buttonLayout `Close
        );hiDisplayAppDBox
);procedure


