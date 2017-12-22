# encoding: utf-8

#  Copyright (c) 2008-2017, Puzzle ITC GmbH. This file is part of
#  Cryptopus and licensed under the Affero General Public License version 3 or later.
#  See the COPYING file at the top-level directory or at
#  https://github.com/puzzle/cryptopus.

require 'test_helper'
require 'test/unit'

class RemovedLdapUsersTest < ActiveSupport::TestCase

#  test 'non admin user cannot run task' do
#    task = MaintenanceTasks::RemovedLdapUsers.new(users(:bob))
#    task.execute
#    assert_match(/Only admin/, Log.first.output)
#  end
end
