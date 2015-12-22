# $Id$

# Copyright (c) 2007 Puzzle ITC GmbH. All rights reserved.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

class Account < ActiveRecord::Base
  belongs_to :group
  has_many :items, :dependent => :destroy

  def as_json(options = { })
    h = super(options)
    h[:group] = group.name
    h[:team] = group.team.name
    h[:team_id] = group.team.id
    h.delete('description')
    h.delete('created_at')
    h.delete('updated_at')
    h
  end

  def label
    accountname
  end

end
