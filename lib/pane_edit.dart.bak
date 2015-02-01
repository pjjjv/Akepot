
import 'package:polymer/polymer.dart';
import 'package:akepot/model/model_project.dart';

@CustomTag("pane-edit")
class PaneEdit extends PolymerElement {
  PaneEdit.created() : super.created();

  @published Project project;

  void toInput (event) {
        var span = $(event.target).closest('span');
        var label = span.find('label:first');
        var input = span.find("input:first");
        label.css("visibility", "hidden");
        input.css("visibility", "inherit");
        input.focus();
  }

  toLabel(event) {
        var span = $(event.target).closest('span');
        var label = span.find('label:first');
        var input = span.find("input:first");
        input.css("visibility", "hidden");
        label.css("visibility", "inherit");

        return input;
  }

  void allToLabels(event) {
        var formspan = $(event.target).closest('span').parent().parent().parent().parent();
        var spans = formspan.find('span');
        spans.each( function (){
          var label = $(this).find('label:first');
          var input = $(this).find("input:first");
          if (input.attr('id') === 'newitem'){
            //do nothing
          } else {
            input.css("visibility", "hidden");
          }
          label.css("visibility", "inherit");
        });
  }

  void updateName(input, taskid) {
        var newName = String(input.val() || "Category");
        check(newName, String);
        Tasks.update(taskid, {$set: {name: newName}});
        input.val('');
  }

  void updatePerson(input, taskid) {
        var newPerson = String(input.val() || "?");
        check(newPerson, String);
        Tasks.update(taskid, {$set: {person: newPerson}});
        input.val('');
  }

  void drag(ev)
  {
    ev.dataTransfer.setData("Text",ev.target.id);
  }

  void allowDrop(ev)
  {
    ev.preventDefault();
  }

  void findPartialTaskDiv(element) {
    var parent = $(element).closest('div').parent();
    if (parent.attr("id") === "taskslist"){//TODO
       return element;
    }
    return parent;
  }

  void drop(ev, newStatus)
  {
    console.log('drop! on inProgress');
    console.log('drop on '+newStatus+', targetClass='+$(ev.currentTarget).attr("class"));
    ev.preventDefault();
    var taskid=ev.dataTransfer.getData("Text");
    console.log(taskid);
    Tasks.update(taskid, {$set: {status: newStatus}});

    if (newStatus === "done") {
      Tasks.update(taskid, {$set: {remainingTime: 0}});
    }

    findPartialTaskDiv($(ev.currentTarget)).removeClass('dragover');
  }


  ////////// Helpers for in-place editing //////////

  // Returns an event map that handles the "escape" and "return" keys and
  // "blur" events on a text input (given by selector) and interprets them
  // as "ok" or "cancel".
  void okCancelEvents = function (selector, callbacks) {
    var ok = callbacks.ok || function () {};
    var cancel = callbacks.cancel || function () {};

    var events = {};
    events['keyup '+selector+', keydown '+selector+', focusout '+selector] =
      function (evt) {
        if (evt.type === "keydown" && evt.which === 27) {
          // escape = cancel
          cancel.call(this, evt);

        } else if (evt.type === "keyup" && evt.which === 13 ||
                   evt.type === "focusout") {
          // blur/return/enter = ok/submit if non-empty
          var value = String(evt.target.value || "");
          if (value)
            ok.call(this, value, evt);
          else
            cancel.call(this, evt);
        }
      };

    return events;
  };


  void onDragOver (e, t) {
    e.preventDefault();
    findPartialTaskDiv($(e.currentTarget)).addClass('dragover');
    allowDrop(e);
  }

  void onDragStart (e, t) {
   drag(e);
  }

  void onDragLeave (e, t) {
    findPartialTaskDiv($(e.currentTarget)).removeClass('dragover');
  }

  void onDrop(e, t) {
    e.preventDefault();
    drop(e, "wait");
  }


  void onOk (text, evt) {//TODO: #newtask
    Tasks.insert({name: text, remainingTime: 0, person: '?', status: 'wait'});
    evt.target.value = '';
  }

  void onTap (event) {
    allToLabels(event);
    toInput(event);
  },

  void onKeyPress(event) {
    if(event.which == 13) {
      var input = toLabel(event);

      updateName(input, this._id);
    }
  }

  void onFocus(event) {
    Session.set("selected_task", this._id);
  }

    /*Template.taskslist.statusIs = function (status) {
      return this.status === status;
    };

    Template.task.selected = function () {
      return Session.equals("selected_task", this._id) ? "selected" : '';
    };

    Template.task.events({
      'focus': function () {
        Session.set("selected_task", this._id);
      }
    });*/

    /*Template.task.events({
      'blur': function () {
        Session.set("selected_task", '');
      }
    });*/
}