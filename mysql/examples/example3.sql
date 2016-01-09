SELECT COUNT(*) FROM users u (INNER JOIN user_attributes ua CROSS JOIN user_attribute_values uav) ON uav.user_id = u.user_id AND uav.attribute_id = ua.attribute_id WHERE u.name = :user_name GROUP BY u.last_name