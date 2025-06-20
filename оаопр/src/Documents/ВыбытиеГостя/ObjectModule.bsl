
Процедура РасчетСтоимостиПроживания()
	    	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
			"ВЫБРАТЬ
			|	ЦенаСуточногоПроживанияСрезПоследних.Цена КАК Цена
			|ИЗ
			|	РегистрСведений.ЦенаСуточногоПроживания.СрезПоследних(&Дата, КласНомера = &Класс) КАК ЦенаСуточногоПроживанияСрезПоследних";
	Запрос.УстановитьПараметр("Дата", ДатаНачала);
	Запрос.УстановитьПараметр("Класс", НомерОтеля.КлассНомера);
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	ВыборкаДетальныеЗаписи.Следующий();
	Цена=ВыборкаДетальныеЗаписи.Цена;
	Если Цена=0 Тогда
		СП=Новый СообщениеПользователю;
		СП.Текст="НЕ ВВедена цена на этот номер!Стоимость не будет посчитана!" ;
		СП.Сообщить();
	КонецЕсли;
	КолДней=Окр((ДатаОкончания-ДатаНачала)/86400,0)+1;
	СтоимостьПроживания=КоличествоМест*Цена*КолДней;
	Если Клиент.ИмеетСкидку Тогда
		Скидка= КоличествоМест*Цена*КолДней*Клиент.ПроцентСкидки/100;
		СтоимостьПроживанияСоСкидкой=СтоимостьПроживания-Скидка;
	КонецЕсли;
	
	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА

	  	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	РасчетСтоимостиПроживания();
	Если СтоимостьПроживания=0 Тогда
		СП=Новый СообщениеПользователю;
		СП.Текст="Стоимость НЕ посчитана!" ;
		СП.Сообщить();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	//{{__КОНСТРУКТОР_ВВОД_НА_ОСНОВАНИИ
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.РазмещениеГостя") Тогда
		// Заполнение шапки
		ДатаНачала = ДанныеЗаполнения.ДатаНачала;
		ДатаОкончания = ДанныеЗаполнения.ДатаОкончания;
		Клиент = ДанныеЗаполнения.Клиент;
		КоличествоМест = ДанныеЗаполнения.КоличествоМест;
		НаличиеСкидки = ДанныеЗаполнения.НаличиеСкидки;
		НомерОтеля = ДанныеЗаполнения.НомерОтеля;
		Организация = ДанныеЗаполнения.Организация;
		СтоимостьПроживанияРанее = ДанныеЗаполнения.СтоимостьПроживания;
		СтоимостьПроживанияСоСкидкойРанее = ДанныеЗаполнения.СтоимостьПроживанияСоСкидкой;
		ДокументОснование = Ссылка;
	КонецЕсли;
	//}}__КОНСТРУКТОР_ВВОД_НА_ОСНОВАНИИ
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	Движения.СостоянияНомеров.Записывать=Истина;
	Если ДокументОснование.ДатаОкончания < ДатаОкончания Тогда
		ТекДата =ДокументОснование.ДатаОкончания;
		Пока ТекДата < ДатаОкончания Цикл
			Движение = Движения.СостоянияНомеров.Добавить();
			Движение.НомерОтеля = НомерОтеля;
			Движение.Дата = ТекДата;
		    Движение.Период=Дата;
			Движение.КоличествоМест = КоличествоМест;
			Движение.Состояние=Перечисления.СостояниеНомера.Свободен;
			ТекДата = ТекДата + 60 * 60 * 24; 
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры



