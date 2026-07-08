export type NotificationCreateDTO = {
  branch_id?: string;
  title: string;
  message: string;
  type: string;
  ref_type: string;
  ref_link: string;
  module: string;
  actor_id?: string;
  receipent_ids: string[];
  channels: string[];
};
