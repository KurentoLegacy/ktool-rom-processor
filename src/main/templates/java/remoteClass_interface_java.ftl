${packageToFolder(model.code.api.java.packageName)}/${remoteClass.name}.java
<#include "macros.ftm" >
/**
 * This file is generated with Kurento ktool-rom-processor.
 * Please don't edit. Changes should go to kms-interface-rom and
 * ktool-rom-processor templates.
 */
package ${model.code.api.java.packageName};

import com.kurento.tool.rom.server.Param;
import com.kurento.tool.rom.RemoteClass;
import com.kurento.tool.rom.server.FactoryMethod;
import java.util.List;

<#list model.allImports as import>
import ${import.model.code.api.java.packageName}.*;
</#list>

<@comment remoteClass.doc />
@RemoteClass
public interface ${remoteClass.name} <#if remoteClass.extends??>extends ${remoteClass.extends.name}</#if> {

   <#list remoteClass.properties as property>
     ${getJavaObjectType(property.type,false)} get${property.name?cap_first}();   
   </#list>
   
   <#list remoteClass.properties as property>
     void get${property.name?cap_first}(Continuation<${getJavaObjectType(property.type,false)}> cont);   
   </#list> 

   <#list remoteClass.methods as method>

	<@comment method.doc method.params method.return />
	${getJavaObjectType(method.return,false)} ${method.name}(<#rt>
		<#lt><#list method.params as param>@Param("${param.name}") ${getJavaObjectType(param.type,false)} ${param.name}<#if param_has_next>, </#if></#list>);

	<#assign doc>
Asynchronous version of ${method.name}:
{@link Continuation#onSuccess} is called when the action is
done. If an error occurs, {@link Continuation#onError} is called.

@see ${remoteClass.name}#${method.name}
    </#assign>
    <@comment doc method.params />
    void ${method.name}(<#rt>
		<#lt><#list method.params as param>@Param("${param.name}") ${getJavaObjectType(param.type,false)} ${param.name}, </#list>Continuation<${getJavaObjectType(method.return)}> cont);

    </#list>
	<#list remoteClass.events as event>
    /**
     * Add a {@link MediaEventListener} for event {@link ${event.name}Event}. Synchronous call.
     *
     * @param  listener Listener to be called on ${event.name}Event
     * @return ListenerRegistration for the given Listener
     *
     **/
    ListenerRegistration add${event.name}Listener(MediaEventListener<${event.name}Event> listener);
    /**
     * Add a {@link MediaEventListener} for event {@link ${event.name}Event}. Asynchronous call.
     * Calls Continuation&lt;ListenerRegistration&gt; when it has been added.
     *
     * @param listener Listener to be called on ${event.name}Event
     * @param cont     Continuation to be called when the listener is registered
     *
     **/
    void add${event.name}Listener(MediaEventListener<${event.name}Event> listener, Continuation<ListenerRegistration> cont);
    </#list>

	<#if !remoteClass.extends??>
    /**
     *
     * Explicitly release a media object form memory. All of its children
     * will also be released.
     *
     **/
    void release();
    /**
     *
     * Explicitly release a media object form memory. All of its children
     * will also be released. Asynchronous call.
     *
     * @param continuation {@link #onSuccess(void)} will be called when the actions complete.
     *                     {@link #onError} will be called if there is an exception.
     *
     **/
	void release(Continuation<Void> continuation);
    </#if>

	<#if !remoteClass.abstract && remoteClass.name != "MediaPipeline">

    public class Builder extends AbstractBuilder<${remoteClass.name}> {

		<#assign doc="Creates a Builder for ${remoteClass.name}" />
		<@comment doc param />
		public Builder(<#rt>
        	<#assign first=true>
        	<#lt><#list remoteClass.constructor.params as param>
        	<#if !param.optional>
            	<#lt><#if first><#assign first=false><#else>, </#if><#rt>
            	<#lt>${getJavaObjectType(param.type,false)} ${param.name}<#rt>
        	</#if>
        	</#list>
        	<#lt>){

			super(${remoteClass.name}.class,${remoteClass.constructor.params[0].name});

        	<#list remoteClass.constructor.params as param>
        	<#if !param.optional>        	
			props.add("${param.name}",${param.name});
        	</#if>
        	</#list>    
		}

        <#list remoteClass.constructor.params as param>
        <#if param.optional>
        <#if param.type.name != "boolean" >
		<#assign par=[param] />		
		<@comment  "Sets a value for ${param.name} in Builder for ${remoteClass.name}." par />
		public Builder with${param.name?cap_first}(${getJavaObjectType(param.type,false)} ${param.name}){
			props.add("${param.name}",${param.name});
			return this;
		}
        <#else>
            <@comment  param.doc />
		public Builder ${param.name}(){
			props.add("${param.name}",Boolean.TRUE);
			return this;
		}
		</#if>
        </#if>
       </#list>
    }
	</#if>
}
