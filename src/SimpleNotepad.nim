import iup
#, streams

#** open func
proc item_open_action_cb(item_open: PIhandle) :cint {.cdecl.} =
  var multitext = iup.getDialogChild(item_open, "MULTITEXT")
  var filedlg = iup.fileDlg()
  iup.setAttribute(filedlg, "DIALOGTYPE", "OPEN")
  iup.setAttribute(filedlg, "EXTFILTER", "Text Files|*.txt|All Files|*.*|")
  iup.setAttributeHandle(filedlg, "PARENTDIALOG", iup.getDialog(item_open))

  iup.popup(filedlg, IUP_CENTERPARENT, IUP_CENTERPARENT)

  if iup.getInt(filedlg, "STATUS") != -1:
    var filename = iup.getAttribute(filedlg, "VALUE")
    var str = read_file($filename)
    if str != "":
      iup.setAttribute(multitext, "VALUE", str)

  iup.destroy(filedlg)
  return IUP_DEFAULT;

#** saveas func
proc item_saveas_action_cb(item_saveas: PIhandle) :cint {.cdecl.} =
  var multitext = iup.getDialogChild(item_saveas, "MULTITEXT")
  var filedlg = iup.fileDlg()
  iup.setAttribute(filedlg, "DIALOGTYPE", "SAVE")
  iup.setAttribute(filedlg, "EXTFILTER", "Text Files|*.txt|All Files|*.*|")
  iup.setAttributeHandle(filedlg, "PARENTDIALOG", iup.getDialog(item_saveas))

  iup.popup(filedlg, IUP_CENTERPARENT, IUP_CENTERPARENT)

  if iup.getInt(filedlg, "STATUS") != -1:
    var filename = iup.getAttribute(filedlg, "VALUE")
    var str = iup.getAttribute(multitext, "VALUE");
#    var count = iup.getInt(multitext, "COUNT");
    writeFile($filename, $str)

  iup.destroy(filedlg);
  return IUP_DEFAULT;

#** exit func
proc item_exit_action_cb(item_exit: PIhandle) :cint {.cdecl.} =
  return IUP_CLOSE;
        
#** main
proc create_main_dialog() =
  discard iup.open(nil,nil)

  var multitext = iup.text(nil)
  iup.setAttribute(multitext, "MULTILINE", "YES")
  iup.setAttribute(multitext, "EXPAND", "YES")
  iup.setAttribute(multitext, "NAME", "MULTITEXT")

  var item_open = iup.item("Open...", nil)
  var item_saveas = iup.item("Save As...", nil)
  var item_exit = iup.item("Exit", nil)
  var item_find = iup.item("Find..", nil)
  var item_goto = iup.item("Go To...", nil)
  var item_font = iup.item("Font...", nil)
  var item_about = iup.item("About...", nil)

  discard iup.setCallback(item_open, "ACTION", (Icallback)item_open_action_cb)
  discard iup.setCallback(item_saveas, "ACTION", (Icallback)item_saveas_action_cb)
  discard iup.setCallback(item_exit, "ACTION", (Icallback)item_exit_action_cb)
#  discard iup.setCallback(item_find, "ACTION", (Icallback)item_find_action_cb)
#  discard iup.setCallback(item_goto, "ACTION", (Icallback)item_goto_action_cb)
#  discard iup.setCallback(item_font, "ACTION", (Icallback)item_font_action_cb)
#  discard iup.setCallback(item_about, "ACTION", (Icallback)item_about_action_cb)

  var file_menu = iup.menu(
    item_open,
    item_saveas,
    iup.separator(),
    item_exit,
    nil)
  var edit_menu = iup.menu(
    item_find,
    item_goto,
    nil)
  var format_menu = iup.menu(
    item_font,
    nil)
  var help_menu = iup.menu(
    item_about,
    nil)

  var sub_menu_file = iup.submenu("File", file_menu)
  var sub_menu_edit = iup.submenu("Edit", edit_menu)
  var sub_menu_format = iup.submenu("Format", format_menu)
  var sub_menu_help = iup.submenu("Help", help_menu)

  var menu = iup.menu(
    sub_menu_file,
    sub_menu_edit,
    sub_menu_format,
    sub_menu_help,
    nil)

  var vbox = iup.vbox(
    multitext,
    nil)

  var dlg = iup.dialog(vbox)
  iup.setAttributeHandle(dlg, "MENU", menu)
  iup.setAttribute(dlg, "TITLE", "Simple Notepad")
  iup.setAttribute(dlg, "SIZE", "HALFxHALF")

  iup.setAttributeHandle(nil, "PARENTDIALOG", dlg)

  discard iup.showXY(dlg, IUP_CENTERPARENT, IUP_CENTERPARENT)
  iup.setAttribute(dlg, "USERSIZE", nil)

  discard iup.mainLoop()

  iup.close()

when isMainModule:
  create_main_dialog()
