<?php
class CRM_Event_Cart_Page_AddToCart extends CRM_Core_Page {
  function run() {
    //by jana
    $checkbox=$_POST['checkbox'];
    $submit= $_POST['submit'];
    if(isset($checkbox)&& isset($submit)){
    $transaction = new CRM_Core_Transaction();
    foreach($checkbox as $k=>$v){ 
     
    if (!CRM_Core_Permission::check('register for events')) {
      CRM_Core_Error::fatal(ts('You do not have permission to register for this event'));
    }
    if (!CRM_Core_Permission::event(CRM_Core_Permission::VIEW, $v)) {
      CRM_Core_Error::fatal(ts('You cannot register for an event you do not have permission to view'));
    }
    $cart = CRM_Event_Cart_BAO_Cart::find_or_create_for_current_session();
    $event_in_cart = $cart->add_event($v); 
    $url=CRM_Utils_System::url('civicrm/event/view_cart');
    //CRM_Utils_System::setUFMessage(ts("<b>%1</b> has been added to your cart. <a href='%2'>View your cart.</a>", array(1 => $event_in_cart->event->title,2 => $url)));
    CRM_Core_Session::setStatus(ts("<b>%1</b> has been added to your cart.", array(1 => $event_in_cart->event->title,2 => $url)));
    }
    $transaction->commit();
    CRM_Core_Session::setStatus(ts("<a href='%2'>View your cart.</a>",array(1 => $event_in_cart->event->title,2 => $url)));
    
    }
    else {
    $transaction = new CRM_Core_Transaction();
    $this->_id = CRM_Utils_Request::retrieve('id', 'Positive', $this, TRUE);
    if (!CRM_Core_Permission::check('register for events')) {
      CRM_Core_Error::fatal(ts('You do not have permission to register for this event'));
    }
    if (!CRM_Core_Permission::event(CRM_Core_Permission::VIEW, $this->_id)) {
      CRM_Core_Error::fatal(ts('You cannot register for an event you do not have permission to view'));
    }
    $cart = CRM_Event_Cart_BAO_Cart::find_or_create_for_current_session();
    $event_in_cart = $cart->add_event($this->_id);
    $url=CRM_Utils_System::url('civicrm/event/view_cart');
    //CRM_Utils_System::setUFMessage(ts("<b>%1</b> has been added to your cart. <a href='%2'>View your cart.</a>", array(1 => $event_in_cart->event->title,2 => $url)));
    CRM_Core_Session::setStatus(ts("<b>%1</b> has been added to your cart <br/>. <a href='%2'>View your cart.</a>", array(1 => $event_in_cart->event->title,2 => $url)));
    $transaction->commit();  
    } 
    return CRM_Utils_System::redirect($_SERVER['HTTP_REFERER']);   
  }
}                



