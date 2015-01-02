!function(i,t){var e=0,s=function(i,t,e){this.target=i,this.currentTime=t,this.timelineTime=e,this.type="finish",this.bubbles=!1,this.cancelable=!1,this.currentTarget=i,this.defaultPrevented=!1,this.eventPhase=Event.AT_TARGET,this.timeStamp=Date.now()};i.Player=function(i){this._sequenceNumber=e++,this._currentTime=0,this._startTime=null,this.paused=!1,this._playbackRate=1,this._inTimeline=!0,this._finishedFlag=!1,this.onfinish=null,this._finishHandlers=[],this._source=i,this._inEffect=this._source._update(0),this._idle=!0,this._currentTimePending=!1},i.Player.prototype={_ensureAlive:function(){this._inEffect=this._source._update(this.currentTime),this._inTimeline||!this._inEffect&&this._finishedFlag||(this._inTimeline=!0,i.timeline._players.push(this))},_tickCurrentTime:function(i,t){i!=this._currentTime&&(this._currentTime=i,this.finished&&!t&&(this._currentTime=this._playbackRate>0?this._totalDuration:0),this._ensureAlive())},get currentTime(){return this._idle||this._currentTimePending?null:this._currentTime},set currentTime(t){t=+t,isNaN(t)||(i.restart()&&(this._startTime=null),this.paused||null==this._startTime||(this._startTime=this._timeline.currentTime-t/this._playbackRate),this._currentTimePending=!1,this._currentTime!=t&&(this._tickCurrentTime(t,!0),i.invalidateEffects()))},get startTime(){return this._startTime},set startTime(t){t=+t,isNaN(t)||this.paused||this._idle||(this._startTime=t,this._tickCurrentTime((this._timeline.currentTime-this._startTime)*this.playbackRate),i.invalidateEffects())},get playbackRate(){return this._playbackRate},get finished(){return!this._idle&&(this._playbackRate>0&&this._currentTime>=this._totalDuration||this._playbackRate<0&&this._currentTime<=0)},get _totalDuration(){return this._source._totalDuration},get playState(){return this._idle?"idle":null==this._startTime&&!this.paused&&0!=this.playbackRate||this._currentTimePending?"pending":this.paused?"paused":this.finished?"finished":"running"},play:function(){this.paused=!1,(this.finished||this._idle)&&(this._currentTime=this._playbackRate>0?0:this._totalDuration,i.invalidateEffects()),this._finishedFlag=!1,this._startTime=i.restart()?null:this._timeline.currentTime-this._currentTime/this._playbackRate,this._idle=!1,this._ensureAlive()},pause:function(){this.finished||this.paused||this._idle||(this._currentTimePending=!0),this._startTime=null,this.paused=!0},finish:function(){this._idle||(this.currentTime=this._playbackRate>0?this._totalDuration:0,this._startTime=this._totalDuration-this.currentTime,this._currentTimePending=!1)},cancel:function(){this._inEffect=!1,this._idle=!0,this.currentTime=0,this._startTime=null},reverse:function(){this._playbackRate*=-1,this.play()},addEventListener:function(i,t){"function"==typeof t&&"finish"==i&&this._finishHandlers.push(t)},removeEventListener:function(i,t){if("finish"==i){var e=this._finishHandlers.indexOf(t);e>=0&&this._finishHandlers.splice(e,1)}},_fireEvents:function(i){var t=this.finished;if((t||this._idle)&&!this._finishedFlag){var e=new s(this,this._currentTime,i),n=this._finishHandlers.concat(this.onfinish?[this.onfinish]:[]);setTimeout(function(){n.forEach(function(i){i.call(e.target,e)})},0)}this._finishedFlag=t},_tick:function(i){return this._idle||this.paused||(null==this._startTime?this.startTime=i-this._currentTime/this.playbackRate:this.finished||this._tickCurrentTime((i-this._startTime)*this.playbackRate)),this._currentTimePending=!1,this._fireEvents(i),!this._idle&&(this._inEffect||!this._finishedFlag)}},WEB_ANIMATIONS_TESTING&&(t.Player=i.Player)}(webAnimationsMinifill,webAnimationsTesting);