package global.sesoc.team.dao;

import java.util.List;
import java.util.Map;

import global.sesoc.team.vo.Business;


public interface BusinessMapper {

	
	public int insertBusiness(Business business);
	public List<Business> selectAll();
	public List<Business> businessMy(String empId);
	public int selectBusinessWith();
	public int deleteBusinessNo(Map<String, String> map);
	public String checkRepresent(String businessWith);
	public int checkBusiness(Map<String, String> map);
	public String selectRepersenter(Map<String, String> map);
	public Integer alreadyBusiness(Map<String, String> map);
}
