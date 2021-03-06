#  Copyright (c) 2008-2017, Puzzle ITC GmbH. This file is part of
#  Cryptopus and licensed under the Affero General Public License version 3 or later.
#  See the COPYING file at the top-level directory or at
#  https://github.com/puzzle/cryptopus.

class Api::Team::MembersController < ApiController

  def index
    authorize team, :team_member?
    members = team.teammembers.list
    render_json members
  end

  def candidates
    authorize team, :team_member?
    candidates = team.member_candidates
    render_json candidates
  end

  def create
    authorize team, :add_member?
    new_member = User.find(params[:user_id])

    decrypted_team_password = team.decrypt_team_password(current_user, session[:private_key])

    team.add_user(new_member, decrypted_team_password)

    add_info(t('flashes.api.members.added', username: new_member.username))
    render_json ''
  end

  def destroy
    authorize team, :remove_member?
    teammember.destroy!

    username = User.find(params[:id]).username
    add_info(t('flashes.api.members.removed', username: username))
    render_json ''
  end

  private

  def teammember
    @teammember ||= team.teammembers.find_by(user_id: params[:id])
  end
end
