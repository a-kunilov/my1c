﻿
Процедура ЗаполнитьРоли() Экспорт
	
	РолиПользователя = Неопределено;
	
	Если ЗначениеЗаполнено(Пользователь) Тогда
		
		
		УИДПользователя = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Пользователь, "ИдентификаторПользователяИБ");
		
		Если ЗначениеЗаполнено(УИДПользователя) Тогда
			
			ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(УИДПользователя);
			
			Если НЕ ПользовательИБ = Неопределено Тогда
				
				РолиПользователя = ПользовательИБ.Роли;
				
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
	Роли.Очистить();
	
	Для каждого СтрокаРоль Из Метаданные.Роли Цикл
		
		Если ТолькоРолиТМС Тогда
			Если НЕ Лев(СтрокаРоль.Имя, 2) = "уп" Тогда
				Продолжить;
			КонецЕсли;
		КонецЕсли;
					
		НоваяСтрока = Роли.Добавить();
		НоваяСтрока.Синоним = СтрокаРоль.Синоним;
		НоваяСтрока.Имя 	= СтрокаРоль.Имя;
		
		Если ЗначениеЗаполнено(РолиПользователя) Тогда
			НоваяСтрока.Флаг = РолиПользователя.Содержит(СтрокаРоль);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Функция СформироватьОтчет() Экспорт
	
	СформироватьДеревоПрав();
	
	Колонки = дрвПраваДоступа.Колонки;
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	Макет = ЭтотОбъект.ПолучитьМакет("Макет");
	
	ОбластьШапкаОбъект 		= Макет.ПолучитьОбласть("Шапка|Объект");
	ОбластьШапкаРоль		= Макет.ПолучитьОбласть("Шапка|Роль"); 
	ОбластьСтрокаКоллекция	= Макет.ПолучитьОбласть("СтрокаКоллекция|Объект"); 
	ОбластьСтрокаОбъект		= Макет.ПолучитьОбласть("СтрокаОбъект|Объект"); 
	ОбластьСтрокаПрава		= Макет.ПолучитьОбласть("СтрокаПрава|Объект"); 
	ОбластьОбъектЕстьПраво	= Макет.ПолучитьОбласть("СтрокаОбъект|Роль"); 
	ОбластьЕстьПраво		= Макет.ПолучитьОбласть("СтрокаПрава|Роль"); 
	
	ТабличныйДокумент.Вывести(ОбластьШапкаОбъект);
	
	Для каждого Колонка Из Колонки Цикл
		Если НЕ Колонка.Имя = "Объект" Тогда
			ОбластьШапкаРоль.Параметры.Роль = Колонка.Заголовок;
			ТабличныйДокумент.Присоединить(ОбластьШапкаРоль);
		КонецЕсли;
	КонецЦикла;
	
	Для каждого СтрокаКоллекция из дрвПраваДоступа.Строки Цикл
		ОбластьСтрокаКоллекция.Параметры.ИмяКоллекции = СтрокаКоллекция.Объект;
		ТабличныйДокумент.Вывести(ОбластьСтрокаКоллекция);
		ТабличныйДокумент.НачатьГруппуСтрок();
		Для каждого СтрокаОбъект Из СтрокаКоллекция.Строки Цикл
			
			СтрокиПрава = СтрокаОбъект.Строки;
			Если НЕ СтрокаКоллекция = "Подсистемы" Тогда
				Если СтрокиПрава.Количество() = 0 Тогда
					Если ВсеОбъектыТМС Тогда
						Если НЕ Лев(СтрокаОбъект.Объект, 2) = "уп" Тогда
							Продолжить;
						КонецЕсли;			
					Иначе
						Продолжить;		
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			
			ОбластьСтрокаОбъект.Параметры.ИмяОбъекта = СтрокаОбъект.Объект;
			ТабличныйДокумент.Вывести(ОбластьСтрокаОбъект);
			ТабличныйДокумент.НачатьГруппуСтрок(,Ложь);
			Для каждого Колонка Из Колонки Цикл
				Если НЕ Колонка.Имя = "Объект" Тогда
					ОбластьОбъектЕстьПраво.Параметры.ЕстьПравоОбъекта = ?(СтрокаОбъект[Колонка.Имя],"+","");
					ТабличныйДокумент.Присоединить(ОбластьОбъектЕстьПраво);
				КонецЕсли;
			КонецЦикла;
			
			Для каждого СтрокаПраво Из СтрокиПрава Цикл
				ОбластьСтрокаПрава.Параметры.ИмяПрава = СтрокаПраво.Объект;
				ТабличныйДокумент.Вывести(ОбластьСтрокаПрава);
				
				Для каждого Колонка Из Колонки Цикл
					Если НЕ Колонка.Имя = "Объект" Тогда
						ОбластьЕстьПраво.Параметры.ЕстьПраво = ?(СтрокаПраво[Колонка.Имя],"+","");
						ТабличныйДокумент.Присоединить(ОбластьЕстьПраво);
					КонецЕсли;
				КонецЦикла;
				
			КонецЦикла;			
			ТабличныйДокумент.ЗакончитьГруппуСтрок();
		КонецЦикла;
		ТабличныйДокумент.ЗакончитьГруппуСтрок();
		
	КонецЦикла;
	
	ТабличныйДокумент.ФиксацияСлева = 4;
	ТабличныйДокумент.ФиксацияСверху = 4;

	
	Возврат ТабличныйДокумент;
			
КонецФункции

Процедура СформироватьДеревоПрав()
	
	дрвПраваДоступа = Новый ДеревоЗначений;
	
	мсвСтроки = Роли.НайтиСтроки(Новый Структура("Флаг", Истина));
	
	дрвПраваДоступа.Колонки.Добавить("Объект");
	
	Для каждого СтрокаРоль Из мсвСтроки Цикл
		дрвПраваДоступа.Колонки.Добавить(СтрокаРоль.Имя,Новый ОписаниеТипов("Булево"),СтрокаРоль.Синоним);
	КонецЦикла;
	
	//	Всевозможные права
	//	Чтение (Read) - чтение; 
	//	Добавление (Insert) - добавление; 
	//	Изменение (Update) - изменение; 
	//	Удаление (Delete) - удаление; 
	//	Проведение (Posting) - проведение документов; 
	//	ОтменаПроведения (UndoPosting) - отмена проведения документов; 
	//	Просмотр (View) - просмотр; 
	//	ИнтерактивноеДобавление (InteractiveInsert) - интерактивное добавление; 
	//	Редактирование (Edit) - редактирование; 
	//	ИнтерактивнаяПометкаУдаления (InteractiveSetDeletionMark) - интерактивная пометка на удаление; 
	//	ИнтерактивноеСнятиеПометкиУдаления (InteractiveClearDeletionMark) - интерактивное снятие пометки на удаление; 
	//	ИнтерактивноеУдалениеПомеченных (InteractiveDeleteMarked) - интерактивное удаление помеченных объектов; 
	//	ИнтерактивноеПроведение (InteractivePosting) - интерактивное проведение; 
	//	ИнтерактивноеПроведениеНеОперативное (InteractivePostingRegular) - интерактивное проведение (стандартными командами форм) документа в неоперативном режиме; 
	//	ИнтерактивнаяОтменаПроведения (InteractiveUndoPosting) - интерактивная отмена проведения; 
	//	ИнтерактивноеИзменениеПроведенных (InteractiveChangeOfPosted) - интерактивное редактирование проведенного документа. Если право не установлено, то пользователь не может проведенный документ удалить, установить пометку удаления, перепровести или сделать непроведенным. Форма такого документа открывается в режиме просмотра; 
	//	ВводПоСтроке (InputByString) - использование режима ввода по строке; 
	//	УправлениеИтогами (TotalsControl) - управление итогами регистра бухгалтерии и регистра накопления (установка периода, по который рассчитаны итоги, и пересчет итогов); 
	//	Использование (Use) - использование; 
	//	ИнтерактивноеУдаление (InteractiveDelete) - интерактивное непосредственное удаление; 
	//	Администрирование (Administration) - администрирование информационной базы; требуется наличия права "Администрирование данных"; 
	//	АдминистрированиеДанных (DataAdministration) - право на административные действия над данными; 
	//	МонопольныйРежим (ExclusiveMode) - использование монопольного режима; 
	//	АктивныеПользователи (ActiveUsers) - просмотр списка активных пользователей; 
	//	ЖурналРегистрации (EventLog) - журнал регистрации; 
	//	ВнешнееСоединение (ExternalConnection) - внешнее соединение; 
	//	Automation (Automation) - использование automation; 
	//	ИнтерактивноеОткрытиеВнешнихОбработок (InteractiveOpenExtDataProcessors) - интерактивное открытие внешних обработок; 
	//	ИнтерактивноеОткрытиеВнешнихОтчетов (InteractiveOpenExtReports) - интерактивное открытие внешних отчетов; 
	//	Получение (Get) - получение значения, не хранящегося в базе данных; 
	//	Установка (Set) - установка значения, не сохраняемого в базе данных; 
	//	ИнтерактивнаяАктивация (InteractiveActivate) - интерактивная активация; 
	//	Старт (Start) - старт бизнес-процесса; 
	//	ИнтерактивныйСтарт (InteractiveStart) - интерактивный старт бизнес-процесса; 
	//	Выполнение (Execute) - выполнение задачи; 
	//	ИнтерактивноеВыполнение (InteractiveExecute) - интерактивное выполнение задачи; 
	//	Вывод (Output) - вывод на печать, запись и копирование в буфер обмена; 
	//	ОбновлениеКонфигурацииБазыДанных (UpdateDataBaseConfiguration) - обновление конфигурации базы данных; 
	//	ТонкийКлиент (ThinClient) - право запуска тонкого клиента; 
	//	ВебКлиент (WebClient) - право запуска веб-клиента; 
	//	ТолстыйКлиент (ThickClient) - право запуска толстого клиента; 
	//	РежимВсеФункции (AllFunctionsMode) - право на использования режима "Все функции"; 
	//	СохранениеДанныхПользователя (SaveUserData) - право на сохранение данных пользователя (настроек, избранного, истории); 
	//	ИзменениеСтандартнойАутентификации (StandardAuthenticationChange) - пользователь имеет право изменять свои сохраненные параметры стандартной аутентификации внешнего источника данных; 
	//	ИзменениеСтандартнойАутентификацииСеанса (SessionStandardAuthenticationChange) - пользователь имеет право изменять параметры стандартной аутентификации внешнего источника данных для текущего сеанса; 
	//	ИзменениеАутентификацииОССеанса (SessionOSAuthenticationChange) - пользователь имеет право изменять параметры стандартной аутентификации внешнего источника данных для текущего сеанса и текущего пользователя; 
	//	ИнтерактивноеУдалениеПредопределенныхДанных (InteractiveDeletePredefinedData) - интерактивное удаление предопределенных данных; 
	//	ИнтерактивнаяПометкаУдаленияПредопределенныхДанных (InteractiveSetDeletionMarkPredefinedData) - интерактивная пометка предопределенных данных; 
	//	ИнтерактивноеСнятиеПометкиУдаленияПредопределенных (InteractiveClearDeletionMarkPredefinedData) - интерактивное снятие пометки предопределенных данных; 
	//	ИнтерактивноеУдалениеПомеченныхПредопределенныхДан (InteractiveDeleteMarkedPredefinedData) - интерактивное удаление помеченных предопределенных данных; 
	//	АдминистрированиеРасширенийКонфигурации (ConfigExtensionsAdministration) - право на администрирование расширений конфигурации.
	
	
	мсвПраваДоступаКонфигурация = Новый Массив;
	мсвПраваДоступаКонфигурация.Добавить("Администрирование");
	мсвПраваДоступаКонфигурация.Добавить("АдминистрированиеДанных");
	мсвПраваДоступаКонфигурация.Добавить("ОбновлениеКонфигурацииБазыДанных");
	мсвПраваДоступаКонфигурация.Добавить("МонопольныйРежим");
	мсвПраваДоступаКонфигурация.Добавить("АктивныеПользователи");
	мсвПраваДоступаКонфигурация.Добавить("ЖурналРегистрации");
	мсвПраваДоступаКонфигурация.Добавить("ВнешнееСоединение");
	мсвПраваДоступаКонфигурация.Добавить("ИнтерактивноеОткрытиеВнешнихОбработок");
	мсвПраваДоступаКонфигурация.Добавить("ИнтерактивноеОткрытиеВнешнихОтчетов");
	мсвПраваДоступаКонфигурация.Добавить("РежимВсеФункции");
	мсвПраваДоступаКонфигурация.Добавить("Вывод");
	мсвПраваДоступаКонфигурация.Добавить("ТонкийКлиент");
	мсвПраваДоступаКонфигурация.Добавить("ВебКлиент");
	мсвПраваДоступаКонфигурация.Добавить("ТолстыйКлиент");
	мсвПраваДоступаКонфигурация.Добавить("ВнешнееСоединение");
	мсвПраваДоступаКонфигурация.Добавить("СохранениеДанныхПользователя");
	мсвПраваДоступаКонфигурация.Добавить("АдминистрированиеРасширенийКонфигурации");
	
	ЗаполнитьПраваДоступа(Метаданные, мсвПраваДоступаКонфигурация, "Конфигурация");
	
	
	мсвПраваДоступаПодсистемы = Новый Массив;
	мсвПраваДоступаПодсистемы.Добавить("Просмотр");
	
	ЗаполнитьПраваДоступа(Метаданные.Подсистемы, мсвПраваДоступаПодсистемы, "Подсистемы");
	
	мсвПраваОбщиеФормы		= Новый Массив;
	мсвПраваОбщиеФормы.Добавить("Просмотр");
	ЗаполнитьПраваДоступа(Метаданные.ОбщиеФормы, мсвПраваОбщиеФормы, "Общие формы");
	 	
	мсвПраваОбщиеКоманды	= Новый Массив;
	мсвПраваОбщиеКоманды.Добавить("Просмотр");
	
	ЗаполнитьПраваДоступа(Метаданные.ОбщиеКоманды, мсвПраваОбщиеКоманды, "Общие команды");
	
	мсвПраваКонстанты		= Новый Массив;
	мсвПраваКонстанты.Добавить("Чтение");
	мсвПраваКонстанты.Добавить("Изменение");
	мсвПраваКонстанты.Добавить("Просмотр");
	мсвПраваКонстанты.Добавить("Редактирование");
	
	ЗаполнитьПраваДоступа(Метаданные.Константы, мсвПраваКонстанты, "Константы");
	
	мсвПраваСправочники		= Новый Массив;
	мсвПраваСправочники.Добавить("Чтение");
	мсвПраваСправочники.Добавить("Добавление");
	мсвПраваСправочники.Добавить("Изменение");
	мсвПраваСправочники.Добавить("Удаление");
	мсвПраваСправочники.Добавить("Просмотр");
	мсвПраваСправочники.Добавить("ИнтерактивноеДобавление");
	мсвПраваСправочники.Добавить("Редактирование");
	мсвПраваСправочники.Добавить("ИнтерактивноеУдаление");
	мсвПраваСправочники.Добавить("ИнтерактивнаяПометкаУдаления");
	мсвПраваСправочники.Добавить("ИнтерактивноеСнятиеПометкиУдаления");
	мсвПраваСправочники.Добавить("ИнтерактивноеУдалениеПомеченных");
	мсвПраваСправочники.Добавить("ВводПоСтроке");
	мсвПраваСправочники.Добавить("ИнтерактивноеУдалениеПредопределенныхДанных");
	мсвПраваСправочники.Добавить("ИнтерактивнаяПометкаУдаленияПредопределенныхДанных");
	мсвПраваСправочники.Добавить("ИнтерактивноеСнятиеПометкиУдаленияПредопределенныхДанных");
	мсвПраваСправочники.Добавить("ИнтерактивноеУдалениеПомеченныхПредопределенныхДанных");
	
	ЗаполнитьПраваДоступа(Метаданные.Справочники, мсвПраваСправочники, "Справочники");
	
	мсвПраваДокумента	= Новый Массив;
	мсвПраваДокумента.Добавить("Чтение");
	мсвПраваДокумента.Добавить("Добавление");
	мсвПраваДокумента.Добавить("Изменение");
	мсвПраваДокумента.Добавить("Удаление");
	мсвПраваДокумента.Добавить("Проведение");
	мсвПраваДокумента.Добавить("ОтменаПроведения");
	мсвПраваДокумента.Добавить("Просмотр");
	мсвПраваДокумента.Добавить("ИнтерактивноеДобавление");
	мсвПраваДокумента.Добавить("Редактирование");
	мсвПраваДокумента.Добавить("ИнтерактивноеУдаление");
	мсвПраваДокумента.Добавить("ИнтерактивнаяПометкаУдаления");
	мсвПраваДокумента.Добавить("ИнтерактивноеСнятиеПометкиУдаления");
	мсвПраваДокумента.Добавить("ИнтерактивноеУдалениеПомеченных");
	мсвПраваДокумента.Добавить("ИнтерактивноеПроведение");
	мсвПраваДокумента.Добавить("ИнтерактивноеПроведениеНеОперативное");
	мсвПраваДокумента.Добавить("ИнтерактивнаяОтменаПроведения");
	мсвПраваДокумента.Добавить("ИнтерактивноеИзменениеПроведенных");
	мсвПраваДокумента.Добавить("ВводПоСтроке");
	
	ЗаполнитьПраваДоступа(Метаданные.Документы, мсвПраваДокумента, "Документы");
	
	мсвПраваЖурналаДокументов	= Новый Массив;
	мсвПраваЖурналаДокументов.Добавить("Чтение");
	мсвПраваЖурналаДокументов.Добавить("Просмотр");
	
	ЗаполнитьПраваДоступа(Метаданные.ЖурналыДокументов, мсвПраваЖурналаДокументов, "Журналы документов");
	
	мсвПраваОтчетов	= Новый Массив;
	мсвПраваОтчетов.Добавить("Использование");
	мсвПраваОтчетов.Добавить("Просмотр");
	
	ЗаполнитьПраваДоступа(Метаданные.Отчеты, мсвПраваОтчетов, "Отчеты");
	
	мсвПраваОбработок	= Новый Массив;
	мсвПраваОбработок.Добавить("Использование");
	мсвПраваОбработок.Добавить("Просмотр");
	
	ЗаполнитьПраваДоступа(Метаданные.Обработки, мсвПраваОбработок, "Обработки");
	
	мсвПраваРегистровСведений	= Новый Массив;
	мсвПраваРегистровСведений.Добавить("Чтение");
	мсвПраваРегистровСведений.Добавить("Изменение");
	мсвПраваРегистровСведений.Добавить("Просмотр");
	мсвПраваРегистровСведений.Добавить("Редактирование");
	мсвПраваРегистровСведений.Добавить("УправлениеИтогами");
	
	ЗаполнитьПраваДоступа(Метаданные.РегистрыСведений, мсвПраваРегистровСведений, "Регистры сведений");
	
	мсвПраваРегистровНакопления	= Новый Массив;
	мсвПраваРегистровНакопления.Добавить("Чтение");
	мсвПраваРегистровНакопления.Добавить("Изменение");
	мсвПраваРегистровНакопления.Добавить("Просмотр");
	мсвПраваРегистровНакопления.Добавить("Редактирование");
	мсвПраваРегистровНакопления.Добавить("УправлениеИтогами");
	
	ЗаполнитьПраваДоступа(Метаданные.РегистрыНакопления, мсвПраваРегистровНакопления, "Регистры накопления");
	
		
КонецПроцедуры

Процедура ЗаполнитьПраваДоступа(КоллекцияОбъектов, мсвПраваДоступа, Наименование = "")

	СтрокаКоллекция = дрвПраваДоступа.Строки.Добавить();
	СтрокаКоллекция.Объект = Наименование;
	
	мсвВыделенныеРоли = Роли.НайтиСтроки(Новый Структура("Флаг", Истина));
	
	Если Наименование = "Конфигурация" Тогда
		СтрокаОбъект = СтрокаКоллекция.Строки.Добавить();
		СтрокаОбъект.Объект = КоллекцияОбъектов.Имя;
		ЗаполнитьСтрокиПоОбъекту(СтрокаОбъект, мсвПраваДоступа, КоллекцияОбъектов, мсвВыделенныеРоли);	
		
	Иначе	
		Для каждого текОбъектМетаданных Из КоллекцияОбъектов Цикл
			
			Если Наименование = "Подсистемы" Тогда
				ЗаполнитьСтрокиПоПодсистеме(СтрокаКоллекция.Строки, мсвПраваДоступа, текОбъектМетаданных, мсвВыделенныеРоли);
			Иначе	
				СтрокаОбъект = СтрокаКоллекция.Строки.Добавить();
				СтрокаОбъект.Объект = текОбъектМетаданных.Имя;
				ЗаполнитьСтрокиПоОбъекту(СтрокаОбъект, мсвПраваДоступа, текОбъектМетаданных, мсвВыделенныеРоли);	
			КонецЕсли;
			
		КонецЦикла;
	
	КонецЕсли;
		
КонецПроцедуры

Процедура ЗаполнитьСтрокиПоОбъекту(СтрокаОбъект, мсвПраваДоступа, текОбъектМетаданных, мсвВыделенныеРоли)
	Для каждого текПравоДоступа Из мсвПраваДоступа Цикл
		СтрокиПрав 	= СтрокаОбъект.Строки;
		мсвСтрока 	= СтрокиПрав.НайтиСтроки(Новый Структура("Объект", текПравоДоступа));
		Если мсвСтрока.Количество() > 0 Тогда
			СтрокаПраво = мсвСтрока[0];
		Иначе	
			СтрокаПраво = Неопределено;
		КонецЕсли;
		Для каждого СтрокаРоль Из мсвВыделенныеРоли Цикл
			
			МетаданныеРоль = Метаданные.Роли.Найти(СтрокаРоль.Имя);
			Если НЕ МетаданныеРоль = Неопределено И ПравоДоступа(текПравоДоступа, текОбъектМетаданных, МетаданныеРоль) Тогда
				Если СтрокаПраво = Неопределено Тогда
					СтрокаПраво = СтрокиПрав.Добавить();
					СтрокаПраво.Объект = текПравоДоступа;
				КонецЕсли;
				СтрокаПраво[СтрокаРоль.Имя] 	= Истина;
				СтрокаОбъект[СтрокаРоль.Имя]	= Истина;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

Процедура ЗаполнитьСтрокиПоПодсистеме(СтрокаКоллекция, мсвПраваДоступа, текОбъектМетаданных, мсвВыделенныеРоли)
	СтрокаОбъект = Неопределено;
	Для каждого текПравоДоступа Из мсвПраваДоступа Цикл
		Для каждого СтрокаРоль Из мсвВыделенныеРоли Цикл
			МетаданныеРоль = Метаданные.Роли.Найти(СтрокаРоль.Имя);
			Если НЕ МетаданныеРоль = Неопределено И ПравоДоступа(текПравоДоступа, текОбъектМетаданных, МетаданныеРоль) Тогда
				Если СтрокаОбъект = Неопределено Тогда
					СтрокаОбъект = СтрокаКоллекция.Добавить(); 
					СтрокаОбъект.Объект = текОбъектМетаданных.Имя;	
				КонецЕсли;
				СтрокаОбъект[СтрокаРоль.Имя]	= Истина;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Для каждого текПодсистема Из текОбъектМетаданных.Подсистемы Цикл
		
		НоваяСтрока = Неопределено;
		
		Для каждого текПравоДоступа Из мсвПраваДоступа Цикл
			Для каждого СтрокаРоль Из мсвВыделенныеРоли Цикл
				МетаданныеРоль = Метаданные.Роли.Найти(СтрокаРоль.Имя);
				Если НЕ МетаданныеРоль = Неопределено И НоваяСтрока = Неопределено И ПравоДоступа(текПравоДоступа, текПодсистема, МетаданныеРоль) Тогда
					Если СтрокаОбъект = Неопределено Тогда
						СтрокаОбъект = СтрокаКоллекция.Добавить(); 
						СтрокаОбъект.Объект = текОбъектМетаданных.Имя;
					КонецЕсли;
					СтрокаОбъект[СтрокаРоль.Имя]	= Ложь;
					
					Если НоваяСтрока = Неопределено Тогда
						НоваяСтрока = СтрокаОбъект.Строки.Добавить();
						НоваяСтрока.Объект 			= текПодсистема.Имя;
					КонецЕсли;
					НоваяСтрока[СтрокаРоль.Имя]	= Истина;
				
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры





