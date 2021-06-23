#
# This file is part of the LibreOffice project.
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#
# This file incorporates work covered by the following license notice:
#
#   Licensed to the Apache Software Foundation (ASF) under one or more
#   contributor license agreements. See the NOTICE file distributed
#   with this work for additional information regarding copyright
#   ownership. The ASF licenses this file to you under the Apache
#   License, Version 2.0 (the "License"); you may not use this file
#   except in compliance with the License. You may obtain a copy of
#   the License at http://www.apache.org/licenses/LICENSE-2.0 .
import traceback

from .TaskEvent import TaskEvent

class Task:
    successful = 0
    failed = 0
    maximum = 0
    taskName = ""
    listeners = []
    subtaskName = ""

    def __init__(self, taskName_, subtaskName_, max_):
        self.taskName = taskName_
        self.subtaskName = subtaskName_
        self.maximum = max_

    def start(self):
        self.fireTaskStarted()

    def fail(self):
        self.fireTaskFailed()

    def getMax(self):
        return self.maximum

    def setMax(self, max_):
        self.maximum = max_
        self.fireTaskStatusChanged()

    def advance(self, success_):
        if success_:
            self.successful += 1
            print ("Success :", self.successful)
        else:
            self.failed += 1
            print ("Failed :", self.failed)
        self.fireTaskStatusChanged()
        if (self.failed + self.successful == self.maximum):
            self.fireTaskFinished()

    def fireTaskStatusChanged(self):
        te = TaskEvent(self, TaskEvent.TASK_STATUS_CHANGED)
        for i in range(len(self.listeners)):
            self.listeners[i].taskStatusChanged(te)

    def fireTaskStarted(self):
        te = TaskEvent(self, TaskEvent.TASK_STARTED)
        for i in range(len(self.listeners)):
            self.listeners[i].taskStarted(te)

    def fireTaskFailed(self):
        te = TaskEvent(self, TaskEvent.TASK_FAILED)
        for i in range(len(self.listeners)):
            self.listeners[i].taskFinished(te)

    def fireTaskFinished(self):
        te = TaskEvent(self, TaskEvent.TASK_FINISHED)
        for i in range(len(self.listeners)):
            self.listeners[i].taskFinished(te)
