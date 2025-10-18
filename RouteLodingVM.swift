//
//  RouteLodingVM.swift
//  Try-Local
//
//  Created by 시모니의 맥북 on 10/2/25.
//

import Foundation

class RouteLodingVM {
    struct LoadingItem {
        let name: String
        let imgURL: String
        let Q: String
        let A: String
    }

    let loadingItems: [LoadingItem] = [
        // 1. 카페야
        LoadingItem(
            name: "카페야",
            imgURL: "https://trylocalbucket.s3.ap-northeast-2.amazonaws.com/카페야/KakaoTalk_20250810_141257141.jpg",
            Q: "직접 방문한 앱 개발자가 느낀 사장님 성격은?",
            A: "보기와 다르게 부끄러움이 많으시고 에겐녀 스타일"
        ),
        LoadingItem(
            name: "카페야",
            imgURL: "https://trylocalbucket.s3.ap-northeast-2.amazonaws.com/카페야/KakaoTalk_20250810_141257141_03.jpg",
            Q: "사장님이 생각하는 카페야의 분위기는?",
            A: "편안한 분위기로 눈치를 보지 않고 동네 마실처럼 방문할 수 있는 카페"
        ),
        LoadingItem(
            name: "카페야",
            imgURL: "https://trylocalbucket.s3.ap-northeast-2.amazonaws.com/카페야/KakaoTalk_20250810_141257141_14.jpg",
            Q: "딸기와 고구마도 재배하신다는 소문이?",
            A: "직접 재배한 딸기와 고구마로 딸기주스와 겨울철에는 군고구마도 판매"
        ),
        
        // 2. 성주달콤참외
        LoadingItem(
            name: "성주달콤참외",
            imgURL: "https://trylocalbucket.s3.ap-northeast-2.amazonaws.com/성주달콤참외/KakaoTalk_20250810_125938213_05.jpg",
            Q: "사장님이 생각하는 우리 농장의 매리트는?",
            A: "몇 명이 와도 상관없어요. 저울 위 숫자만 중요! 1kg 당 만원."
        ),
        LoadingItem(
            name: "성주달콤참외",
            imgURL: "https://trylocalbucket.s3.ap-northeast-2.amazonaws.com/성주달콤참외/KakaoTalk_20250810_125938213_01.jpg",
            Q: "사장님이 경험했던 손님 중 가장 손에 꼽는 빌런은?",
            A: "주머니에 참외를 숨기고 무게를 재는 사람(다 티납니다.)"
        ),
        
        // 3. 고소애농장
        LoadingItem(
            name: "고소애농장",
            imgURL: "https://trylocalbucket.s3.ap-northeast-2.amazonaws.com/고소애농장/건강애굳.jpg",
            Q: "고소애는 왜 고소애인가?",
            A: "기존 명칭인 갈색거저리의 거부감을 줄이기 위해 공모전을 통해 선정된 고소한 애벌레에서 유래"
        ),
        LoadingItem(
            name: "고소애농장",
            imgURL: "https://trylocalbucket.s3.ap-northeast-2.amazonaws.com/고소애농장/KakaoTalk_20250809_153241716_02.jpg",
            Q: "직접 방문한 앱 개발자가 느낀 사장님 성격은?",
            A: "완벽한 테토남 그자체"
        ),
        LoadingItem(
            name: "고소애농장",
            imgURL: "https://trylocalbucket.s3.ap-northeast-2.amazonaws.com/고소애농장/KakaoTalk_20250809_153241716_03.jpg",
            Q: "사장님의 말씀 중 가장 기억에 남는 말씀은?",
            A: "'요즘 애들은 배고픔을 모른다.' 힘든 일도 해보며 너무 쉽게 포기하지 말라는 당부"
        ),
        
        // 4. 별고을승마장
        LoadingItem(
            name: "별고을승마장",
            imgURL: "https://trylocalbucket.s3.ap-northeast-2.amazonaws.com/별고을승마장/KakaoTalk_20250810_182746987_04.jpg",
            Q: "별고을승마장의 말들이 가장 좋아하는 간식은?",
            A: "보고도 믿지 못했던 건빵 식탐"
        ),
        LoadingItem(
            name: "별고을승마장",
            imgURL: "https://trylocalbucket.s3.ap-northeast-2.amazonaws.com/별고을승마장/KakaoTalk_20250810_182746987_07.jpg",
            Q: "사장님이 생각하는 우리 농장의 매리트는?",
            A: "넓은 농장을 자유롭게 누비며 여유시간을 즐기는 말들의 자유시간 존재"
        ),
        LoadingItem(
            name: "별고을승마장",
            imgURL: "https://trylocalbucket.s3.ap-northeast-2.amazonaws.com/별고을승마장/KakaoTalk_20250815_235827285.jpg",
            Q: "앱 개발자가 방문할 때 당황했던 순간은?",
            A: "사진속 이정표를 믿으세요.(이 길 맞습니다.)"
        ),
        
        // 5. 다미떡카페
        LoadingItem(
            name: "다미떡카페",
            imgURL: "https://trylocalbucket.s3.ap-northeast-2.amazonaws.com/다미떡카페/KakaoTalk_20250814_201911321.jpg",
            Q: "사장님이 강조하는 다미떡카페의 시그니처 메뉴는?",
            A: "군수님도 즐겨 찾는다는 사과시루떡"
        ),
        LoadingItem(
            name: "다미떡카페",
            imgURL: "https://trylocalbucket.s3.ap-northeast-2.amazonaws.com/다미떡카페/KakaoTalk_20250814_201911321_01.jpg",
            Q: "앱 개발자가 가게에 처음 방문했을 때, 들었던 오해는?",
            A: "'요즘 이런 광고 사기 많던데…' (개발자: 저희는 정직한 '이거해봄' 팀입니다.)"
        ),
        LoadingItem(
            name: "다미떡카페",
            imgURL: "https://trylocalbucket.s3.ap-northeast-2.amazonaws.com/다미떡카페/KakaoTalk_20250809_174650223.jpg",
            Q: "사장님이 생각하는 우리 가게의 매리트는?",
            A: "하나씩 주머니에 넣어 먹을 수 있는 낱개 포장"
        ),
        
        // 6. 경성표고버섯농장
        LoadingItem(
            name: "경성표고버섯농장",
            imgURL: "https://trylocalbucket.s3.ap-northeast-2.amazonaws.com/경성표고버섯농장/버섯음료.jpg",
            Q: "앱 개발자에게 사장님이 내어주신 버섯음료의 맛은?",
            A: "버섯맛보다 뜻밖의 사과맛 음료(원재료 중 사과농축액 포함)"
        ),
        
        // 7. 회연서원
        LoadingItem(
            name: "회연서원",
            imgURL: "https://trylocalbucket.s3.ap-northeast-2.amazonaws.com/회연서원/방문록2.jpg",
            Q: "앱 개발자가 회연서원 방문 중 기억에 남는 것은?",
            A: "뜻밖의 놓여져 있는 많은 사람들이 작성한 수기 방명록"
        ),
        
        // 8. 성주생활문화센터
        LoadingItem(
            name: "성주생활문화센터",
            imgURL: "https://trylocalbucket.s3.ap-northeast-2.amazonaws.com/성주생활문화센터/KakaoTalk_20250809_124931081_02.jpg",
            Q: "앱 개발자가 성주생활문화센터 방문 중 기억에 남는 것은?",
            A: "설치된 짚라인이 그렇게 재밌음.(속도감 장난아님)"
        ),
        
        // 9. 개발자들의 성주 방문 TMI
        LoadingItem(
            name: "개발자들의 성주 방문 TMI",
            imgURL: "https://trylocalbucket.s3.ap-northeast-2.amazonaws.com/거리.jpg",
            Q: "아침 7시 출발 1박2일 일정",
            A: "성주는 생각보다 가볼 곳이 많다. 참외 한 박스 획득(큰 참외, 작은 참외 크기 상관 없이 맛있다.)"
        ),
        LoadingItem(
            name: "개발자들의 성주 방문 TMI",
            imgURL: "https://trylocalbucket.s3.ap-northeast-2.amazonaws.com/거리.jpg",
            Q: "앱 개발자가 성주를 방문하면서 중요하게 생각한 것은?",
            A: "장소 방문이 밥보다 우선(오전5시 기상 후 첫끼는 오후 5시..)"
        ),
        LoadingItem(
            name: "개발자들의 성주 방문 TMI",
            imgURL: "https://trylocalbucket.s3.ap-northeast-2.amazonaws.com/거리.jpg",
            Q: "앱 개발자가 성주에서 먹은 첫날 저녁밥은?(1박2일 일정)",
            A: "말복이어서 치킨 먹음ㅎㅎ.."
        ),
        LoadingItem(
            name: "개발자들의 성주 방문 TMI",
            imgURL: "https://trylocalbucket.s3.ap-northeast-2.amazonaws.com/거리.jpg",
            Q: "앱 개발자가 성주 탐방 39시간 동안 느낀 점은?",
            A: "성주는 생각보다 가볼 곳이 많다."
        )
    ]
}
