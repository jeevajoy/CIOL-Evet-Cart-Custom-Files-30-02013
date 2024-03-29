{*
 +--------------------------------------------------------------------+
 | CiviCRM version 4.2                                                |
 +--------------------------------------------------------------------+
 | Copyright CiviCRM LLC (c) 2004-2012                                |
 +--------------------------------------------------------------------+
 | This file is a part of CiviCRM.                                    |
 |                                                                    |
 | CiviCRM is free software; you can copy, modify, and distribute it  |
 | under the terms of the GNU Affero General Public License           |
 | Version 3, 19 November 2007 and the CiviCRM Licensing Exception.   |
 |                                                                    |
 | CiviCRM is distributed in the hope that it will be useful, but     |
 | WITHOUT ANY WARRANTY; without even the implied warranty of         |
 | MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.               |
 | See the GNU Affero General Public License for more details.        |
 |                                                                    |
 | You should have received a copy of the GNU Affero General Public   |
 | License and the CiviCRM Licensing Exception along                  |
 | with this program; if not, contact CiviCRM LLC                     |
 | at info[AT]civicrm[DOT]org. If you have questions about the        |
 | GNU Affero General Public License or the licensing of CiviCRM,     |
 | see the CiviCRM license FAQ at http://civicrm.org/licensing        |
 +--------------------------------------------------------------------+
*}

{* Displays current and upcoming public Events Listing as an HTML page. *}
{include file="CRM/common/jsortable.tpl"}
<table id="options" class="display">
<thead>
<tr>
    <th>{ts}Select{/ts}</th>
    <th>{ts}Event{/ts}</th>
    <th>{ts}{/ts}</th>
    <th>{ts}When{/ts}</th>
    <th>{ts}Location{/ts}</th>
    <th>{ts}Category{/ts}</th>
    <th>{ts}Fee{/ts}</th>
     <th>{ts}Email{/ts}</th>
     {if $registration_links}<th>{ts}Register{/ts}</th>{/if}
    <th>{ts}{/ts}</th>
    
</tr>
</thead> 
{foreach from=$events key=uid item=event} 
{if $event.parent_event_id}   
<tr class="{cycle values="odd-row,even-row"} {$row.class}">
     {*{$event|@print_r};*}
   
    <form method="post"  action="index.php?option=com_civicrm&task=civicrm/event/add_to_cart"> 
    <td><input name="checkbox[]" type="checkbox" id="checkbox[]" value="{$event.event_id}"></td>
    <td><a href="{crmURL p='civicrm/event/info' q="reset=1&id=`$event.event_id`"}" title="{ts}read more{/ts}"><strong>{$event.title}</strong></a></td>
    <td>{if $event.summary}{$event.summary} (<a href="{crmURL p='civicrm/event/info' q="reset=1&id=`$event.event_id`"}" title="{ts}details...{/ts}">{ts}read more{/ts}...</a>){else}&nbsp;{/if}</td>
    <td class="nowrap">
        {if $event.start_date}{$event.start_date|crmDate}{if $event.end_date}<br /><em>{ts}through{/ts}</em><br />{strip}
            {* Only show end time if end date = start date *}
            {if $event.end_date|date_format:"%Y%m%d" == $event.start_date|date_format:"%Y%m%d"}
                {$event.end_date|crmDate:0:1}
            {else}
                {$event.end_date|crmDate}
            {/if}{/strip}{/if}
        {else}{ts}(not available){/ts}{/if}
    </td>
    <td>{if $event.is_show_location EQ 1 AND $event.location}{$event.location}{else}{ts}(not available){/ts}{/if}</td>
    <td>{if $event.event_type}{$event.event_type}{else}&nbsp;{/if}</td> 
     <td>{if $event.fee_amount}{$config->defaultCurrencySymbol}{$event.fee_amount}{else}&nbsp;{/if}</td> 
    <td>{if $event.contact_email}<a href="mailto:{$event.contact_email}">{$event.contact_email}</a>{else}&nbsp;{/if}</td>
   {if $registration_links}<td><a href="{$event.registration_link}">{$event.registration_link_text}</a></td>{/if}
    
</tr>
{/if}
{/foreach}  
</table>
<!----Added By Add and View Cart Buttons Jag 22-01-2013---->
<div class="block-crm">
  <table width="5%">
    <tr>
      <td  width="5%">
        <form  method="post"  action="index.php?option=com_civicrm&task=civicrm/event/add_to_cart">
        <input type="submit" class="form-submit default" id="submit" name="submit" value="Add">  
        </form> 
      </td>
      <td>  
        <a class="button" href="{crmURL p='civicrm/event/view_cart'}" accesskey='e'><span>View Cart</span></a>
      </td>
    </tr>
  </table>   
</div>
<!----End of code Jag 22-01-2013---->

 
 



