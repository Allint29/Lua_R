term = require('term')
term.clear()

--�������� ��� ������, ������������ � ����� �������


-- ==========C������� ����� ������, ��� ������������ �����===============
-- ����������: � ������ ����� ������, �� ��� �� ����������� �����, ��� ��� �� ��������� ��������� ���������������
-- �������� ������, �� ���� ���������� ������.  ���������� ������ ����� ������ ����������� � ��� ������
-- ����� ���� �� ���� ����������� �����, �� � ����������� ������� ��� ������� ������, ������, ��� ��� �� �� �� 
-- ������ ������ �� ��������� �� �������, �� �������.
print('============ ���������� ����������  ===========')


ClassPlayers = {} 

-- ������ ����������������� ����, ��������� � ������ ������ ������ 
function ClassPlayers:new(age, uuid, ip) 
	local obj = {} 
	obj.age = age or nil -- �������, �� ��������� nil 
	obj.uuid = uuid or 'uuid' -- �� ��������� 'uuid' 
	obj.ip = ip or '1.1.1.1' -- �� ��������� '1.1.1.1'
	
	--����� ���������� ������� � �����
	setmetatable(obj,self) 
	self.__index = self
	return obj -- ���������� ��� ������ (��������� ������)
end 

-- ������� ��������� ������� 
function ClassPlayers:get() 
	return self.age, self.uuid, self.ip
end 

-- ������� ��������� �������
function ClassPlayers:set(age, uuid, ip) 
	self.age = age 
	self.uuid = uuid
	self.ip = ip
end 


-- �������� ����� ������ �������! ��� ���������� �������, ���������� ������ ������
Alex = ClassPlayers:new(36, "abc-zxc-1234567-vvv", '192.168.1.0') -- �� ������� ������ �����, � �������� ���� �����-�� ��������
Bob = ClassPlayers:new(28, "zxc-qwe-0987654-bbb", '192.168.1.2') -- �� ������� ������ ���, � �������� ���� �����-�� ��������

print('>>> �������� ������ �����')
print(Alex:get())


print('>>> ������ ������ � ���������, ��� ����������')
Alex:set( 35, '111-aaa-bbb', '192.168.1.1') 
print(Alex:get()) 




-- =========�������� �������� ��������������==========
ClassAdmins = {} 

--����� � ����� ��������� ����� ���� ����� ��� � ����� ���-���, � ��� �� ���� ��������������� ����� ���
function ClassAdmins:blabla() 
	print('�������, ����� ���-��� � ������ \'������\' ����������') -- ����� ����� ���� ���, ��� ������, �� ����
end

--������ ����� ����� ����� ���
function ClassAdmins:ban(user) 
	print ('���� '..user..' ������� ������ ������!!!')
end 

--�������������� ������ ��� � ��������� ������
function ClassAdmins:get() 
	return "��� ���� ������, ���� ����� � ������� ���� :)" 
end 

--����������� �� ������������� ������ ������
setmetatable(ClassAdmins,{__index = ClassPlayers}) 

-- ������� ���������� ���� ������ ���������� ��� �������, ����� �����, ��� ����� new ������������ � ������������� ������ ������. �� ��� ��� ���� ���
-- ������, � ��� �� ����� ����� ������ � ���� � ������ ��� �������. ���, c��� �� �����, �������� ������ ���.

print('>>> ������� � ��������� ������ ������, ���� ��� �����-�� ������� �� ���������')  -- �� ��� ��� ��������������� ������
GringoStar = ClassAdmins:new() --������� ������ ������ �� ����������� ���������� ������, �� �� ������ ���� ��� �������, ���� � ����� ����!!!
print(ClassPlayers.get(GringoStar))

print('>>> ������ ������ ������ ��� ��� ��� �������� ����')
GringoStar:set(23, "555-666-sssssss-uuu", '192.168.255.255') -- �������� ������ ��������, ����� set ���� ������ ��� � ������ ������!!!

print('>>> ������� ����� ��� � �������')
print(ClassAdmins:get())

print('>>> ������� ����� ��� � ������� ��� ������ ������')
-- ���������: �����������������.�����(���_������, ���������)
print(ClassPlayers.get(GringoStar))

print('>>> ������� ����� ���-��� � �������')
ClassAdmins:blabla() 

print('>>> ������� ����� ��� � ������� � � �������� ���������\n��������� �� ����������� ������ ���� �� 3-�')
ClassAdmins:ban('����') 

print('>>> ��������� � ���������� �������� ������')
print(Alex.age)

print('>>> ����� ��� �� 50, Alex.age = 50')
Alex.age = 50

print('>>> ������ �������� age ������   : ',Alex.age)
print('>>> ������ �������� uuid ������  : ',GringoStar.uuid)

---��� ����������? �����, �� ���� � ������� ���, ������ �������� ����� ���������� � �������� ������ ������, �� ���� ��������� ��,
---� ����� ����� ���� �������� � ������ ������ ������.