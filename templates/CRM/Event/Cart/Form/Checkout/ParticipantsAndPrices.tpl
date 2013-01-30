
{include file="CRM/common/TrackingFields.tpl"}

{capture assign='reqMark'}<span class="marker"  title="{ts}This field is required.{/ts}">*</span>{/capture}
<!----display Nembership Number field added by Jag 10 oct 2012  --->
 <div class="label">
 {$form.membershipNumber.label} 
 </div>
 <div class="content">
 {$form.membershipNumber.html}
 </div>
 <!----End of code by Jag 10 oct 2012  --->
 <div class="label">
 {$form.emails.label} 
 </div>
 <div class="content">
 {$form.emails.html}
 </div>
{if $contact}
<div class="messages status">
    {ts 1=$contact.display_name}Welcome %1{/ts}. (<a href="{crmURL p='civicrm/event/cart_checkout' q="&cid=0&reset=1"}" title="{ts}Click here to register a different person for this event.{/ts}">{ts 1=$contact.display_name}Not %1, or want to register a different person{/ts}</a>?)</div>
{/if}
{include file="CRM/Event/Cart/Form/Checkout/Participant.tpl"}
{foreach from=$events_in_carts key=index item=event_in_cart}  
{/foreach}  
 {assign var=event_id value=$event_in_cart->event_id}  
 <!--- <h3 class="event-title">
    {$event_in_cart->event->title} ({$event_in_cart->event->start_date|date_format:"%m/%d/%Y %l:%M%p"})
  </h3>   -->
  <fieldset class="event_form">
    <div class="participants crm-section" id="event_{$event_in_cart->event_id}_participants"> 
      {foreach from=$event_in_cart->participants item=participant}
	  {include file="CRM/Event/Cart/Form/Checkout/Participant.tpl"} 
      {/foreach}
      <!----<a class="link-add" href="#" onclick="add_participant({$event_in_cart->event_cart->id}, {$event_in_cart->event_id}); return false;">{ts}Add Another Participant{/ts}</a> -->
    </div>
    {if $event_in_cart->event->is_monetary }
      <div class="price_choices crm-section">
    {foreach from=$price_fields_for_event key=price_index item=price_field_name}
      {counter assign=idx print=0}
	  {foreach from=$price_field_name key=index item=price_field}     
       {if $idx  eq 1}
          <div class="label">         
  	     {$form.$price_field.label}
  	     </div> 
       {/if}
	  <div class="content">
	    {$form.$price_field.html|replace:'/label>&nbsp;':'/label><br>'}
	  </div>
      {/foreach}
	{/foreach}
      </div>
    {else}
      <p>{ts}There is no charge for this event.{/ts}</p>
    {/if}
  </fieldset>   
 

 

<div id="crm-submit-buttons" class="crm-submit-buttons">
  {include file="CRM/common/formButtons.tpl" location="bottom"}
</div>

{include file="CRM/Event/Cart/Form/viewCartLink.tpl"}

{literal}
<script type="text/javascript">
//<![CDATA[
function add_participant( cart_id, event_id ) {
  var max_index = 0;
  var matcher = new RegExp("event_" + event_id + "_participant_(\\d+)");
  
  cj('#event_' + event_id + '_participants .participant').each(
    function(index) {
      matches = matcher.exec(cj(this).attr('id'));
      index = parseInt(matches[1]);
      if (index > max_index)
      {
        max_index = index;
      }
    }
  );

  cj.get("/civicrm/ajax/event/add_participant_to_cart?&cart_id=" + cart_id + "&event_id=" + event_id, 
    function(data) {
      cj('#event_' + event_id + '_participants').append(data);
    }
  );
}

function delete_participant( event_id, participant_id )
{
  cj('#event_' + event_id + '_participant_' + participant_id).remove();
  cj.get("/civicrm/ajax/event/remove_participant_from_cart?id=" + participant_id);
}


//XXX missing
cj('#ajax_error').ajaxError(
  function( e, xrh, settings, exception ) {
    cj(this).append('<div class="error">{/literal}{ts}Error adding a participant at{/ts}{literal} ' + settings.url + ': ' + exception);
  }
);
//]]>


</script>
{/literal}
<!---hide price fields added by Jag 22-01-2013--->
{literal}  
<script type="text/javascript">
 cj(document).ready(function() {
  cj("div[class='price_choices crm-section']").find('input[type=radio]').attr("checked", "checked"); 
  cj("div[class='price_choices crm-section']").hide();
 });
</script>
{/literal} 
<!---end of code added by Jag 22-01-2013--->
