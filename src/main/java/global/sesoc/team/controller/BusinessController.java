package global.sesoc.team.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import global.sesoc.team.dao.BusinessRepository;
import global.sesoc.team.vo.Business;


@Controller
public class BusinessController {
	
	@Autowired
	BusinessRepository repository;
	
	@ResponseBody
	@RequestMapping(value = "insertBusiness", method = RequestMethod.POST)
	public List<Business> insertBusiness(@RequestBody List<Business> BusinessList, HttpSession session) {
		
		String empId = (String) session.getAttribute("loginId");
		int businessWith = repository.selectBusineeWith();
		businessWith = businessWith + 1;

		for (int i = 0; i < BusinessList.size(); i++) {
			if (empId.equals(BusinessList.get(i).getEmpId())) {
				BusinessList.get(i).setBusinessRepresent("true");
			} else {
				BusinessList.get(i).setBusinessRepresent("false");
			}
			BusinessList.get(i).setBusinessWith(businessWith);
			repository.insertBusiness(BusinessList.get(i));

		}
		System.out.println(BusinessList);
		return BusinessList;
	}
	
	@ResponseBody
	@RequestMapping(value="/businessMy" ,method=RequestMethod.GET)
	public List<Business> businessMy (HttpSession session){
		String empId = (String)session.getAttribute("loginId");
		List<Business> Blist = repository.businessMy(empId);
		return Blist;
	}
	
	public String addBusiness(String startDate ,String endDate,Model model) {
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);
		return "calendar/addBusiness";
		
	}
	
	@ResponseBody
	@RequestMapping(value = "/deleteBusiness", method = RequestMethod.GET)
	public boolean deleteBusiness(String selectDate, HttpSession session) {
		Map<String, String> map = new HashMap<String, String>();
		String empId = (String) session.getAttribute("loginId");
		String date = selectDate.replace("-", "/");
		map.put("empId", empId);
		map.put("selectDate", date);
		String representer = repository.selectRepersenter(map);
		if(representer.equals(empId)) {
			repository.deleteBusinessNo(map);
			return true;
		}
			return false;
	}
	@ResponseBody
	@RequestMapping(value = "/checkRepresent", method = RequestMethod.GET)
	public String checkRepresent(String businessWith) {
		String empId = repository.checkRepresent(businessWith);
		return empId;
		
}	
	@ResponseBody
	@RequestMapping(value="/checkBusiness",method = RequestMethod.GET)
	public int checkBusiness(String selectDate,HttpSession session) {
		String sd  = selectDate.replace("-","/");
		String empId = (String)session.getAttribute("loginId");
		Map<String,String> map = new HashMap<String,String>();
		map.put("empId",empId);
		map.put("selectDate", sd);
		int businessNo = repository.checkBusiness(map);
		
		return businessNo;
	}
	
	@ResponseBody
	@RequestMapping(value="/seleteBusinessNo", method=RequestMethod.GET)
	public int seleteBusinessNo(String selectDate,HttpSession session) {
		String empId = (String)session.getAttribute("loginId");
		String sd  = selectDate.replace("-","/");

		Map<String,String> map = new HashMap<String,String>();
		map.put("empId",empId);
		map.put("selectDate", sd);
		Integer businessNo = repository.checkBusiness(map);
		
		
		
		System.out.println(businessNo);
		return businessNo ; 
	}
	@ResponseBody
	@RequestMapping(value="/alreadyBusiness" , method=RequestMethod.GET)
	public boolean alreadyBusiness (String startDate,String endDate,HttpSession session) {
		
		String empId = (String)session.getAttribute("loginId");
		String sd  = startDate.replace("-","/");
		String ed  = endDate.replace("-","/");
		Map<String,String> map1 = new HashMap<String,String>();
		map1.put("empId",empId);
		map1.put("selectDate", sd);
		int result=repository.alreadyBusiness(map1);
		Map<String,String> map2 = new HashMap<String,String>();
		map2.put("empId",empId);
		map2.put("selectDate", ed);
		int result2=repository.alreadyBusiness(map2);
		if(result == 0 && result2 ==0) {
			return true;
		}
		return false;
		
	}
	
	
}
