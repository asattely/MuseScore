//=============================================================================
//  MuseScore
//  Music Composition & Notation
//
//  Copyright (C) 2020 MuseScore BVBA and others
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the GNU General Public License version 2.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program; if not, write to the Free Software
//  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
//=============================================================================

#ifndef MU_NOTATION_NOTATIONTOOLBARMODEL_H
#define MU_NOTATION_NOTATIONTOOLBARMODEL_H

#include <QAbstractListModel>

#include "context/iglobalcontext.h"
#include "modularity/ioc.h"
#include "async/asyncable.h"
#include "actions/iactionsregister.h"
#include "actions/iactionsdispatcher.h"

#include "framework/ui/view/iconcodes.h"
#include "framework/uicomponents/uicomponentstypes.h"
#include "inotationconfiguration.h"

namespace mu::notation {
class NotationToolBarModel : public QAbstractListModel, public async::Asyncable
{
    Q_OBJECT

    INJECT(notation, context::IGlobalContext, context)
    INJECT(notation, actions::IActionsRegister, actionsRegister)
    INJECT(notation, actions::IActionsDispatcher, dispatcher)
    INJECT(notation, INotationConfiguration, configuration)

    Q_PROPERTY(bool isToolBarVisible READ isToolBarVisible WRITE setIsToolBarVisible NOTIFY isToolBarVisibleChanged)

public:
    explicit NotationToolBarModel(QObject* parent = nullptr);

    int rowCount(const QModelIndex& parent = QModelIndex()) const override;
    QVariant data(const QModelIndex& index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void load();
    Q_INVOKABLE void handleAction(const QString& actionCode);

    bool isToolBarVisible() const;

public slots:
    void setIsToolBarVisible(bool visible);

signals:
    void isToolBarVisibleChanged(bool visible);

private:
    enum Roles {
        TitleRole = Qt::UserRole + 1,
        CodeRole,
        IconRole,
        EnabledRole,
        HintRole
    };

    uicomponents::MenuItem makeItem(const actions::ActionCode& actionCode) const;

    QList<uicomponents::MenuItem> m_items;
};
}

#endif // MU_NOTATION_NOTATIONTOOLBARMODEL_H
