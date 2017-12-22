# encoding: utf-8

#  Copyright (c) 2008-2017, Puzzle ITC GmbH. This file is part of
#  Cryptopus and licensed under the Affero General Public License version 3 or later.
#  See the COPYING file at the top-level directory or at
#  https://github.com/puzzle/cryptopus.

require 'test_helper'
require 'test/unit'

class Admin::MaintenanceTasksControllerTest < ActionController::TestCase
  include ControllerTest::DefaultHelper

  context '#index' do

    test 'get all maintenance tasks' do
      login_as(:admin)

      get :index

      maintenance_tasks = assigns(:maintenance_tasks)

      assert_equal 2, maintenance_tasks.size
      assert_equal true, maintenance_tasks.any? { |t| t.class == MaintenanceTasks::RootAsAdmin }
      assert_equal true, maintenance_tasks.any? { |t| t.class == MaintenanceTasks::NewRootPassword }
    end

    test 'index cannot be accessed by non-root' do
      login_as(:bob)

      get :index

      assert_redirected_to teams_path
    end

  end

  context '#prepare' do

    test 'prepare cannot be accessed by non-root' do
      login_as(:bob)

      get :prepare, params: { id: 1 }

      assert_redirected_to teams_path
    end

    test 'shows form with task params' do
      login_as(:admin)

      get :prepare, params: { id: 2 }

      assert_equal MaintenanceTasks::NewRootPassword, assigns(:maintenance_task).class
      assert_select 'h1', text: 'New root password'
      assert_select 'label', text: 'New root password'
      assert_select 'input', id: 'task_params_new_root_password', type: 'password'
      assert_select 'label', text: 'Retype password'
      assert_select 'input', id: 'task_params_retype_password', type: 'password'
    end

    test 'returns 404 if no task params' do
      enable_ldap
      login_as(:admin)

      assert_raise ActionController::RoutingError do
        get :prepare, params: { id: 3 }
      end
    end

  end

  context '#execute' do
    
    test 'execute cannot be accessed by non-root' do
      login_as(:bob)

      post :execute, params: { id: 1 }

      assert_redirected_to teams_path
    end

    test 'execute task' do
      login_as(:admin)
      assert_difference('Log.count', 1) do
        post :execute, params: { id: 2, task_params: {new_root_password: 'password', retype_password: 'password'} }
      end

      assert_redirected_to admin_maintenance_tasks_path
      assert_match(/successfully/, flash[:notice])
    end

    test 'displays error if task execution fails' do
      login_as(:admin)
      assert_difference('Log.count', 1) do
        post :execute, params: { id: 2, task_params: {new_root_password: 'password'} }
      end

      assert_redirected_to admin_maintenance_tasks_path
      assert_match(/Task failed/, flash[:error])
    end

    test 'returns 404 if invalid maintenance task id' do
      enable_ldap
      login_as(:admin)

      assert_raise ActionController::RoutingError do
        post :execute, params: { id: 42, task_params: {} }
      end
    end
    
    test 'executes task and renders result page' do
      enable_ldap
      login_as(:admin)
      assert_difference('Log.count', 1) do
        post :execute, params: { id: 3 }
      end

      assert_template 'admin/maintenance_tasks/removed_ldap_users/result.html.haml'
      assert_match(/successfully/, flash[:notice])
    end

  end
  
  #test 'error message if execute fails' do
    #task = MaintenanceTask.new(users(:admin))
    #MaintenanceTask.stubs(:initialize_task).returns(task)
    #task.stubs(:execute).returns(false)

    #login_as(:admin)
    #post :execute, params: { id: 2, task_params: {root_password: 'password'} }

    #assert_match(/Task failed/, flash[:error])
  #end

  #test 'notice if execute succeed' do
    #task = MaintenanceTask.new(users(:admin))
    #MaintenanceTask.stubs(:initialize_task).returns(task)
    #task.stubs(:execute).returns(true)

    #login_as(:admin)
    #post :execute, params: { id: 2, task_params: {root_password: 'password'} }

    #assert_match(/successfully/, flash[:notice])
  #end

  
  #test 'removed ldap users task available if ldap enabled' do
    #enable_ldap
    #login_as(:admin)
    #post :execute, params: { id: 3, task_params: {label: ':removed_ldap_users'} }
    #assert_equal MaintenanceTasks::RemovedLdapUsers, assigns(:task).class
  #end

##  test 'removed ldap users task unavailable if ldap disabled' do
##    login_as(:admin)
##    assert_raise(NoMethodError) do
##      post :execute, params: { id: 2, task_params: {label: ':removed_ldap_users'} }
##    end
##  end
  
  #test 'renders result page' do
    #enable_ldap
    #login_as(:admin)
    #post :execute, params: { id: 3, task_params: {label: ':removed_ldap_users'} }

    #assert_template "admin/maintenance_tasks/removed_ldap_users/result.html.haml"
  #end

  #test 'renders prepare page' do
    #login_as(:admin)
    #get :prepare, params: { id: 2, task_params: {type: 'password', label: :root_password} }

    #assert_template "admin/maintenance_tasks/prepare"
  #end
end
