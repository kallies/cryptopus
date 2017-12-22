# encoding: utf-8

#  Copyright (c) 2008-2017, Puzzle ITC GmbH. This file is part of
#  Cryptopus and licensed under the Affero General Public License version 3 or later.
#  See the COPYING file at the top-level directory or at
#  https://github.com/puzzle/cryptopus.

class Admin::MaintenanceTasksController < Admin::AdminController

  # GET /admin/maintenance_tasks
  def index
    @maintenance_tasks = MaintenanceTask.list
    @maintenance_logs = Log.where(log_type: 'maintenance_task')
  end

  # GET /admin/maintenance_tasks/1/prepare
  def prepare
    unless maintenance_task.prepare?
      raise ActionController::RoutingError.new('Not Found')
    end

    flash[:notice] = maintenance_task.hint
    flash[:error] = maintenance_task.error
  end

  # POST /admin/maintenance_tasks/1/execute
  def execute
    unless maintenance_task
      raise ActionController::RoutingError.new('Not Found')
    end

    maintenance_task.current_user = current_user
    maintenance_task.param_values = param_values

    result = maintenance_task.execute

    if result
      flash[:notice] = t('flashes.admin.maintenance_tasks.succeed')
    else
      flash[:error] = t('flashes.admin.maintenance_tasks.failed')
    end

    if result && template_exists?(partial)
      render partial
    else
      redirect_to admin_maintenance_tasks_path
    end
  end

  private

  def partial
    "admin/maintenance_tasks/#{maintenance_task.name}/result.html.haml"
  end

  def maintenance_task
    @maintenance_task ||= MaintenanceTask.find(params[:id])
  end

  def param_values
    param_values = { private_key: session[:private_key] }
    param_values.merge!(task_params)
  end

  def task_params
    return {} unless params[:task_params]
    params.require(:task_params).
      permit(:new_root_password, :retype_password, :root_password)
  end

end
