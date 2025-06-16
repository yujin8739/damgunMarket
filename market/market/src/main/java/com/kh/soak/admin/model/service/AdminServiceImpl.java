package com.kh.soak.admin.model.service;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.soak.admin.model.dao.AdminDao;
import com.kh.soak.admin.model.vo.Admin;

@Service
public class AdminServiceImpl implements AdminService {
    
    @Autowired
    private AdminDao dao;
    
    @Autowired
    private SqlSessionTemplate sqlSession;
    
    @Override
    public Admin loginAdmin(Admin admin) {
        return dao.loginAdmin(sqlSession, admin);
    }

    @Override
    public int updateAdmin(Admin admin) {
        return dao.updateAdmin(sqlSession, admin);
    }
    
    @Override
    public int deleteAdmin(Admin admin) {
        return dao.deleteAdmin(sqlSession, admin);
    }
    
    @Override
    public int idCheck(String adminId) {
        return dao.idCheck(sqlSession, adminId);
    }
    
    @Override
    public Admin selectAdminByNum(int adminNum) {
        return dao.selectAdminByNum(sqlSession, adminNum);
    }
}