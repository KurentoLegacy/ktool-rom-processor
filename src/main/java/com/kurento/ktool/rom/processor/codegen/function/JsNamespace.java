package com.kurento.ktool.rom.processor.codegen.function;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import com.kurento.ktool.rom.processor.model.RemoteClass;
import com.kurento.ktool.rom.processor.model.TypeRef;

import freemarker.ext.beans.StringModel;
import freemarker.template.TemplateMethodModelEx;
import freemarker.template.TemplateModelException;

public class JsNamespace implements TemplateMethodModelEx {

	@Override
	public Object exec(@SuppressWarnings("rawtypes") List arguments)
			throws TemplateModelException {

		RemoteClass remoteClass = (RemoteClass) ((StringModel) arguments
				.get(0)).getWrappedObject();
		
		Set<String> baseClassNames = new HashSet<String>();
		baseClassNames.add("Filter");
		baseClassNames.add("Endpoint");
		baseClassNames.add("Hub");
		
		TypeRef extendsRef = remoteClass.getExtends();
		while(extendsRef != null){
			
			RemoteClass parentRemoteClass = (RemoteClass) extendsRef.getType();
			if(baseClassNames.contains(parentRemoteClass.getName())){
				return parentRemoteClass.getName();
			}
			
			extendsRef = parentRemoteClass.getExtends();
		}

		return "None";
	}

}
