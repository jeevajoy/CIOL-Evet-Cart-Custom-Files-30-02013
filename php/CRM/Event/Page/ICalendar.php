<?php
/*
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
*/

/**
 *
 * @package CRM
 * @copyright CiviCRM LLC (c) 2004-2012
 * $Id$
 *
 */

/**
 * ICalendar class
 *
 */
require_once 'CRM/Core/Page.php';
require_once 'CRM/Core/BAO/CustomField.php';
 
class CRM_Event_Page_ICalendar extends CRM_Core_Page {
    /**
   * Heart of the iCalendar data assignment process. The runner gets all the meta
   * data for the event and calls the  method to output the iCalendar
   * to the user. If gData param is passed on the URL, outputs gData XML format.
   * Else outputs iCalendar format per IETF RFC2445. Page param true means send
   * to browser as inline content. Else, we send .ics file as attachment.
   *
   * @return void
   */
   
  function run() {
 
    $id       = CRM_Utils_Request::retrieve('id', 'Positive', $this, FALSE, NULL, 'GET');
    $type     = CRM_Utils_Request::retrieve('type', 'Positive', $this, FALSE, 0);
    $start    = CRM_Utils_Request::retrieve('start', 'Positive', $this, FALSE, 0);
    $end      = CRM_Utils_Request::retrieve('end', 'Positive', $this, FALSE, 0);
    $iCalPage = CRM_Utils_Request::retrieve('list', 'Positive', $this, FALSE, 0);
    $gData    = CRM_Utils_Request::retrieve('gData', 'Positive', $this, FALSE, 0);
    $html     = CRM_Utils_Request::retrieve('html', 'Positive', $this, FALSE, 0);
    $rss      = CRM_Utils_Request::retrieve('rss', 'Positive', $this, FALSE, 0);
   
    $info = CRM_Event_BAO_Event::getCompleteInfo($start, $type, $id, $end); 
    //<!---to show event fee amount not for price sets added by jag 22-01-2013 ---->
    foreach($info as $key => $value){
        $discountId = CRM_Core_BAO_Discount::findSet($value['event_id'], 'civicrm_event');     
        if ($discountId) {
          $price_set_id = CRM_Core_DAO::getFieldValue('CRM_Core_BAO_Discount', $discountId, 'option_group_id');      
        }else{
          $price_set_id = CRM_Price_BAO_Set::getFor('civicrm_event',$value['event_id']);
        }         
        $price_sets = CRM_Price_BAO_Set::getSetDetail($price_set_id, TRUE, TRUE);
        $price_set  = $price_sets[$price_set_id]['fields'];
        foreach($price_set as $k => $v) {
          if(count($v['options']) == 1 ){
            foreach ($v['options'] as $k1 => $v1){               
              $info[$key]['fee_amount'] = $v1['amount'];
            }         
          }        
       } 
    }
    //<!-----end of code by jag 22-01-2013--------------->
    
    $this->assign('events', $info);
    
    $this->assign('timezone', @date_default_timezone_get());
    // Send data to the correct template for formatting (iCal vs. gData)
    $template = CRM_Core_Smarty::singleton();
    $config = CRM_Core_Config::singleton();
    if ($rss) {
      // rss 2.0 requires lower case dash delimited locale
      $this->assign('rssLang', str_replace('_', '-', strtolower($config->lcMessages)));
      $calendar = $template->fetch('CRM/Core/Calendar/Rss.tpl');
      
    }
    elseif ($gData) {
      $calendar = $template->fetch('CRM/Core/Calendar/GData.tpl');
     
    }
      
    elseif ($html) {
      // check if we're in shopping cart mode for events
      $enable_cart = CRM_Core_BAO_Setting::getItem(CRM_Core_BAO_Setting::EVENT_PREFERENCES_NAME,
        'enable_cart'
      );
      
      if ($enable_cart) {
        $this->assign('registration_links', TRUE);
         
      } 
      return parent::run();
    }
    else {
      $calendar = $template->fetch('CRM/Core/Calendar/ICal.tpl');
      $calendar = preg_replace('/(?<!\r)\n/', "\r\n", $calendar);
    }

    // Push output for feed or download
    if ($iCalPage == 1) {   
      if ($gData || $rss) {
        CRM_Utils_ICalendar::send($calendar, 'text/xml', 'utf-8');
      }
      else {
        CRM_Utils_ICalendar::send($calendar, 'text/plain', 'utf-8');
      }
    }
    else {
      CRM_Utils_ICalendar::send($calendar, 'text/calendar', 'utf-8', 'civicrm_ical.ics', 'attachment');
    }
    
    
    
    CRM_Utils_System::civiExit();
  }
  
}
