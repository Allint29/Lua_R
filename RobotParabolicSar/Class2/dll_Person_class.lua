Person = {}
function Person:new(name, age)
    local private = {}
        --��������� ��������
        private.age = age or 18

    local public = {}
        --��������� ��������
        public.name = name or "����"   -- "����" - ��� �������� �� ��������� 
		public.age = age or 23
		
		
        --��������� �����
        function public:getAge()
            return private.age
        end
		
		function public:setAge()
		  --����� ���������� ������ ���� �������� self		  
          private.age = self or 22
		end

    setmetatable(public,self)
    self.__index = self; return public
end