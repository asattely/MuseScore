/*
 * SPDX-License-Identifier: GPL-3.0-only
 * MuseScore-CLA-applies
 *
 * MuseScore
 * Music Composition & Notation
 *
 * Copyright (C) 2021 MuseScore BVBA and others
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */
#ifndef MU_UPDATE_UPDATESCENARIO_H
#define MU_UPDATE_UPDATESCENARIO_H

#include "async/asyncable.h"

#include "modularity/ioc.h"
#include "iinteractive.h"
#include "../iupdateconfiguration.h"
#include "../iupdateservice.h"

#include "../iupdatescenario.h"

namespace mu::update {
class UpdateScenario : public IUpdateScenario, public async::Asyncable
{
    INJECT(update, framework::IInteractive, interactive)
    INJECT(update, IUpdateConfiguration, configuration)
    INJECT(update, IUpdateService, updateService)

public:
    void delayedInit();

    void checkForUpdate() override;

private:
    bool isCheckStarted() const;

    void doCheckForUpdate(bool manual);

    void processUpdateResult(int errorCode);

    void showNoUpdateMsg();
    void showReleaseInfo(const ReleaseInfo& info);

    void showServerErrorMsg();

    void installRelease();

    bool m_progress = false;
};
}

#endif // MU_UPDATE_UPDATESCENARIO_H
