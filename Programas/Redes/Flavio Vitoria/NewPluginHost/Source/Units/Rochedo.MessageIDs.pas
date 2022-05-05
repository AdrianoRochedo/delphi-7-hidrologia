unit Rochedo.MessageIDs;

interface
uses MessageManager;

  var UM_RESET_VISIT               : Integer;
  var UM_GET_OBJECT                : Integer;
  var UM_PAINT_OBJECT              : Integer;
  var UM_LOCK_OBJECT               : Integer;
  var UM_DELETING_OBJECT           : Integer;
  var UM_OBJECT_DESCRIPTION_CHANGE : Integer;
  var UM_OBJECT_COMMENT_CHANGE     : Integer;
  var UM_OBJECT_NAME_CHANGE        : Integer;

(*
type
  pRecObjectPointer = ^TRecObjectPointer;
  TRecObjectPointer = record
                        Obj: TObject;
                      end;
*)
implementation

initialization
  UM_RESET_VISIT               := GetMessageManager.RegisterMessageID('UM_RESET_VISIT');
  UM_GET_OBJECT                := GetMessageManager.RegisterMessageID('UM_GET_OBJECT');
  UM_PAINT_OBJECT              := GetMessageManager.RegisterMessageID('UM_PAINT_OBJECT');
  UM_LOCK_OBJECT               := GetMessageManager.RegisterMessageID('UM_LOCK_OBJECT');
  UM_DELETING_OBJECT           := GetMessageManager.RegisterMessageID('UM_DELETING_OBJECT');
  UM_OBJECT_DESCRIPTION_CHANGE := GetMessageManager.RegisterMessageID('UM_OBJECT_DESCRIPTION_CHANGE');
  UM_OBJECT_COMMENT_CHANGE     := GetMessageManager.RegisterMessageID('UM_OBJECT_COMMENT_CHANGE');
  UM_OBJECT_NAME_CHANGE        := GetMessageManager.RegisterMessageID('UM_OBJECT_NAME_CHANGE');
end.
