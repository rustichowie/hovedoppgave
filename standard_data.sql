INSERT INTO `timeregistrering`.`roles` (`id`, `name`, `description`) VALUES (1, 'Ansatt', 'Vanlig ansatt');
INSERT INTO `timeregistrering`.`roles` (`id`, `name`, `description`) VALUES (2, 'Formann', 'Formann');
INSERT INTO `timeregistrering`.`roles` (`id`, `name`, `description`) VALUES (3, 'Administrator', 'Bruker med fulle rettigheter');

INSERT INTO `users` (`active`, `created_at`, `crypted_password`, `current_login_at`, `current_login_ip`, 
`email`, `employee_id`, `failed_login_count`, `group_id`, `last_login_at`, `last_login_ip`, `last_request_at`, `login_count`, `name`, `perishable_token`, `persistence_token`, `phone_number`, `pin`, `remote_id`, `role_id`, `salt`, `single_access_token`, `updated_at`) VALUES (1, '2013-05-13 16:48:51', '1a6f5dfa34c4fde87369e1cc992e23d227b63301d4d7e2a96f257a6622
49481adaf38a456220b2f3b22c6d0875d66d24468623c51d59a3a54f7182426bc1d37f', '2013-05-13 16:48:51', '127.0.0.1', 'admin@admin.no', NULL, 0, 1, NULL, NULL, '2013-05-13 16:48:51', 1, 'Admin', 'dyYTjYLIZIzZngHGIao7', '6a2a8c38fc3346b6c70c0c7074af1
8835f732ffb87b094263bd24fb8483ac9d7f4122993f2bc61c1ba3d4c387ca42b7e9fabf554fa9a0e515a00cfb119312250', '45454545', 8985, 
NULL, 3, 'OlEuySlszvhro6Qb2Wft', '93rg45DQL79AdAK3h3pf', '2013-05-13 16:48:51');

INSERT INTO `timeregistrering`.`groups` (`id`, `name`) VALUES (1, 'Administratorer');

